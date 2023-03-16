package com.sbhs.swm.implement;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sbhs.swm.dto.request.BookingHomestayRequestDto;
import com.sbhs.swm.handlers.exceptions.BookingNotFoundException;
import com.sbhs.swm.handlers.exceptions.InvalidBookingException;
import com.sbhs.swm.handlers.exceptions.InvalidException;
import com.sbhs.swm.handlers.exceptions.NotFoundException;
import com.sbhs.swm.models.BlocHomestay;
import com.sbhs.swm.models.Booking;
import com.sbhs.swm.models.BookingDeposit;
import com.sbhs.swm.models.Deposit;
import com.sbhs.swm.models.BookingHomestay;
import com.sbhs.swm.models.BookingHomestayService;
import com.sbhs.swm.models.Homestay;
import com.sbhs.swm.models.HomestayService;
import com.sbhs.swm.models.LandlordCommission;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.models.status.BookingStatus;
import com.sbhs.swm.models.status.DepositStatus;
import com.sbhs.swm.models.type.CommissionType;
import com.sbhs.swm.models.type.HomestayType;
import com.sbhs.swm.models.type.PaymentMethod;
import com.sbhs.swm.repositories.DepositRepo;
import com.sbhs.swm.repositories.BookingHomestayRepo;
import com.sbhs.swm.repositories.BookingRepo;
import com.sbhs.swm.repositories.HomestayServiceRepo;
import com.sbhs.swm.repositories.LandlordCommissionRepo;
import com.sbhs.swm.services.IBookingService;
import com.sbhs.swm.services.IHomestayService;
import com.sbhs.swm.services.IMailService;
import com.sbhs.swm.services.IUserService;
import com.sbhs.swm.util.BookingDateValidationString;
import com.sbhs.swm.util.BookingDateValidationUtil;
import com.sbhs.swm.util.DateFormatUtil;

@Service
public class BookingService implements IBookingService {

    @Autowired
    private HomestayServiceRepo homestayServiceRepo;

    @Autowired
    private LandlordCommissionRepo landlordCommissionRepo;

    @Autowired
    private BookingRepo bookingRepo;

    @Autowired
    private BookingHomestayRepo bookingHomestayRepo;

    @Autowired
    private DepositRepo depositRepo;

    @Autowired
    private IUserService userService;

    @Autowired
    private IHomestayService homestayService;

    @Autowired
    private IMailService mailService;

    @Autowired
    private DateFormatUtil dateFormatUtil;

    @Autowired
    private BookingDateValidationUtil bookingDateValidationUtil;

    @Override
    public List<Booking> findBookingsByUsernameAndStatus(String status) {
        SwmUser user = userService.authenticatedUser();
        List<Booking> bookings = bookingRepo.findBookingByUsernameAndStatus(user.getUsername(), status);

        return bookings;
    }

    @Override
    public Booking findBookingById(Long id) {
        Booking booking = bookingRepo.findById(id).orElseThrow(() -> new BookingNotFoundException());

        return booking;
    }

    @Override
    public Boolean canPassengerMakeBooking(long totalBookingPrice) {
        SwmUser user = userService.authenticatedUser();
        long currentTotalPassengerWalletBalance = user.getPassengerProperty().getBalanceWallet().getTotalBalance();
        long totalUnpaidDeposit = depositRepo.getTotalUnpaidAmountFromUser(user.getUsername()) != null
                ? depositRepo.getTotalUnpaidAmountFromUser(user.getUsername())
                : 0;

        long actualPassengerWalletBalance = currentTotalPassengerWalletBalance - totalUnpaidDeposit;
        if (actualPassengerWalletBalance < totalBookingPrice) {
            return false;
        }

        return true;
    }

    @Override
    public List<Homestay> checkBlocBookingDate(String blocName, String bookingStart, String bookingEnd,
            int totalHomestay) {
        BlocHomestay bloc = homestayService.findBlocHomestayByName(blocName);
        List<Homestay> availableHomestays = new ArrayList<>();
        for (Homestay h : bloc.getHomestays()) {
            String validateBookingDateString = bookingDateValidationUtil.bookingValidateString(bookingStart, bookingEnd,
                    h.getName());
            switch (BookingDateValidationString.valueOf(validateBookingDateString)) {
                case INVALID:
                    throw new InvalidBookingException("Invalid booking date");
                case CURRENT_END_ON_BOOKED_END:
                    break;
                case CURRENT_START_ON_BOOKED_END:
                    availableHomestays.add(h);
                    break;
                case CURRENT_START_ON_BOOKED_START:
                    break;
                case ON_BOOKING_PERIOD:
                    break;
                case OK:
                    availableHomestays.add(h);
                    break;
            }
        }
        return availableHomestays;
    }

    @Override
    public Booking createBookingByPassenger() {
        SwmUser user = userService.authenticatedUser();
        if (user.getPassengerProperty().getBookings().stream()
                .anyMatch(b -> b.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name()))) {
            throw new InvalidException("User still have save booking");
        }
        Booking booking = new Booking();
        booking.setPassenger(user.getPassengerProperty());
        booking.setStatus(BookingStatus.SAVED.name());
        booking.setCreatedBy(user.getUsername());
        booking.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
        user.getPassengerProperty().setBookings(List.of(booking));
        Booking savedBooking = bookingRepo.save(booking);

        return savedBooking;
    }

    @Override
    @Transactional
    public BookingHomestay createSaveBookingForHomestay(BookingHomestayRequestDto bookingHomestayRequest) {
        SwmUser passengerUser = userService.authenticatedUser();
        Booking userSaveBooking = passengerUser.getPassengerProperty().getBookings().stream()
                .filter(b -> b.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name())).findFirst()
                .orElseThrow(() -> new NotFoundException("user didn't create any booking"));
        BookingHomestay bookingHomestay = new BookingHomestay();
        Homestay homestayBooking = homestayService.findHomestayByName(bookingHomestayRequest.getHomestayName());
        List<HomestayService> homestayServiceBookingList = bookingHomestayRequest.getHomestayServiceList().stream()
                .map(s -> homestayServiceRepo.findHomestayServiceByName(s).get()).collect(Collectors.toList());
        List<BookingHomestayService> bookingHomestayServiceList = new ArrayList<>();
        Long homestayBookingPrice = homestayBooking.getPrice();
        Long totalHomestayServicePrice = 0L;
        Long totalBookingPrice = 0L;
        Long currentBookingTotalPrice = userSaveBooking.getTotalBookingPrice();
        Long currentBookingTotalDeposit = userSaveBooking.getTotalBookingDeposit();

        for (HomestayService s : homestayServiceBookingList) {
            totalHomestayServicePrice = totalHomestayServicePrice + s.getPrice();
            BookingHomestayService bookingHomestayService = new BookingHomestayService();
            bookingHomestayService.setHomestayService(s);
            bookingHomestayService.setBooking(userSaveBooking);
            bookingHomestayService.setTotalServicePrice(s.getPrice());
            bookingHomestayServiceList.add(bookingHomestayService);
        }
        totalBookingPrice = homestayBookingPrice + totalHomestayServicePrice;
        currentBookingTotalPrice = currentBookingTotalPrice + totalBookingPrice;
        if (passengerUser.getPassengerProperty().getBalanceWallet().getTotalBalance() < currentBookingTotalPrice) {
            throw new InvalidException("You don't have enough balance. Please add more or choose pay by cash.");
        }
        homestayBooking.setBookingHomestays(List.of(bookingHomestay));
        userSaveBooking.setBookingHomestays(List.of(bookingHomestay));
        userSaveBooking.setBookingHomestayServices(bookingHomestayServiceList);
        userSaveBooking.setTotalBookingPrice(currentBookingTotalPrice);
        switch (PaymentMethod.valueOf(bookingHomestayRequest.getPaymentMethod().toUpperCase())) {
            case SWM_WALLET:

                Long paidDeposit = this.getBookingDeposit(totalBookingPrice);
                Long unpaidDeposit = totalBookingPrice - paidDeposit;
                currentBookingTotalDeposit = currentBookingTotalDeposit + paidDeposit;
                userSaveBooking.setTotalBookingDeposit(currentBookingTotalDeposit);
                Deposit deposit = new Deposit();

                BookingDeposit bookingDeposit = new BookingDeposit();
                deposit.setBookingDeposits(List.of(bookingDeposit));
                deposit.setCreatedBy(passengerUser.getUsername());
                deposit.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
                deposit.setPassengerWallet(
                        passengerUser.getPassengerProperty().getBalanceWallet().getPassengerWallet());
                passengerUser.getPassengerProperty().getBalanceWallet().getPassengerWallet()
                        .setDeposits(List.of(deposit));

                bookingDeposit.setPaidAmount(paidDeposit);
                bookingDeposit.setUnpaidAmount(unpaidDeposit);
                bookingDeposit.setDepositForHomestay(homestayBooking.getName());
                bookingDeposit.setBooking(userSaveBooking);
                bookingDeposit.setDeposit(deposit);
                userSaveBooking.setBookingDeposits(List.of(bookingDeposit));
                depositRepo.save(deposit);

                break;
            case CASH:
                break;
        }
        bookingHomestay.setBookingFrom(bookingHomestayRequest.getBookingFrom());
        bookingHomestay.setBookingTo(bookingHomestayRequest.getBookingTo());
        bookingHomestay.setPrice(totalBookingPrice);
        bookingHomestay.setPaymentMethod(bookingHomestayRequest.getPaymentMethod());
        if (homestayBooking.getBloc() != null) {
            bookingHomestay.setHomestayType(HomestayType.BLOC.name());
        } else {
            bookingHomestay.setHomestayType(HomestayType.HOMESTAY.name());
        }
        bookingHomestay.setTotalReservation(bookingHomestayRequest.getTotalReservation());
        bookingHomestay.setHomestay(homestayBooking);
        bookingHomestay.setBooking(userSaveBooking);
        BookingHomestay savedBookingHomestay = bookingHomestayRepo.save(bookingHomestay);

        return savedBookingHomestay;

    }

    @Override
    public List<Booking> findBookingsByHomestayNameAndStatus(String bookingStatus, String homestayName) {
        List<BookingHomestay> bookingHomestays = bookingHomestayRepo.findBookingHomestaysByHomestayName(bookingStatus);
        List<Booking> bookings = bookingHomestays.stream().map(b -> b.getBooking())
                .filter(b -> b.getStatus().equalsIgnoreCase(bookingStatus)).collect(Collectors.toList());

        return bookings;
    }

    @Override
    @Transactional
    public Booking submitBookingByPassenger(Long bookingId) {
        Booking booking = this.findBookingById(bookingId);
        SwmUser passengerUser = booking.getPassenger().getUser();
        List<Homestay> homestaysInBloc = booking.getBookingHomestays().stream()
                .filter(b -> b.getHomestayType().equalsIgnoreCase(HomestayType.BLOC.name()))
                .map(b -> b.getHomestay()).collect(Collectors.toList());
        List<Homestay> homestays = booking.getBookingHomestays().stream()
                .filter(b -> b.getHomestayType().equalsIgnoreCase(HomestayType.HOMESTAY.name()))
                .map(b -> b.getHomestay())
                .collect(Collectors.toList());
        List<SwmUser> homestayOwners = homestays.stream().map(b -> b.getLandlord().getUser())
                .collect(Collectors.toList());

        List<String> getBlocHomestayOwnerNames = homestaysInBloc.stream()
                .map(h -> h.getLandlord().getUser().getUsername()).distinct().collect(Collectors.toList());

        List<SwmUser> blocHomestayOwners = getBlocHomestayOwnerNames.stream()
                .map(n -> userService.findUserByUsername(n)).collect(Collectors.toList());
        for (BookingHomestay b : booking.getBookingHomestays()) {

            Long currentPassengerWalletBalance = passengerUser.getPassengerProperty().getBalanceWallet()
                    .getTotalBalance();
            Long landlordTotalCommission = this.getLandlordCommission(booking.getTotalBookingPrice());
            LandlordCommission landlordCommission = new LandlordCommission();
            switch (PaymentMethod.valueOf(b.getPaymentMethod().toUpperCase())) {
                case CASH:

                    blocHomestayOwners.forEach(landlordUser -> {
                        Long currentLandlordWalletBalance = landlordUser.getLandlordProperty().getBalanceWallet()
                                .getTotalBalance();
                        // kiểm tra nếu số dư đủ trả tiền hoa hồng thì trừ luôn còn không thì ghi nợ
                        if (currentLandlordWalletBalance >= landlordTotalCommission) {
                            Long newLandlordWalletBalance = currentLandlordWalletBalance -
                                    landlordTotalCommission;
                            landlordUser.getLandlordProperty().getBalanceWallet()
                                    .setTotalBalance(newLandlordWalletBalance);

                            landlordCommission.setCommission(landlordTotalCommission);
                            landlordCommission.setCommissionType(CommissionType.PAID_COMMISSION.name());
                            landlordCommission.setLandlordWallet(
                                    landlordUser.getLandlordProperty().getBalanceWallet().getLandlordWallet());
                            landlordUser.getLandlordProperty().getBalanceWallet().getLandlordWallet()
                                    .setLandlordCommissions(List.of(landlordCommission));
                            landlordCommission.setCreatedBy(landlordUser.getUsername());
                            landlordCommission.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
                            landlordCommissionRepo.save(landlordCommission);
                        } else {
                            landlordCommission.setCommission(landlordTotalCommission);
                            landlordCommission.setCommissionType(CommissionType.UNPAID_COMMISSION.name());
                            landlordCommission.setLandlordWallet(
                                    landlordUser.getLandlordProperty().getBalanceWallet().getLandlordWallet());
                            landlordUser.getLandlordProperty().getBalanceWallet().getLandlordWallet()
                                    .setLandlordCommissions(List.of(landlordCommission));
                            landlordCommission.setCreatedBy(landlordUser.getUsername());
                            landlordCommission.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
                            landlordCommissionRepo.save(landlordCommission);
                        }

                    });

                    break;
                case SWM_WALLET:
                    currentPassengerWalletBalance = currentPassengerWalletBalance
                            - booking.getTotalBookingDeposit();
                    // cộng tiền cọc(deposit) vào tk landlord
                    for (BookingDeposit bookingDeposit : b.getBooking().getBookingDeposits()) {
                        Homestay depositForHomestay = homestayService
                                .findHomestayByName(bookingDeposit.getDepositForHomestay());
                        SwmUser owner = depositForHomestay.getLandlord().getUser();
                        Long currentOwnerBalanceWallet = owner.getLandlordProperty().getBalanceWallet()
                                .getTotalBalance();
                        currentOwnerBalanceWallet = currentOwnerBalanceWallet + bookingDeposit.getPaidAmount();
                        owner.getLandlordProperty().getBalanceWallet().setTotalBalance(currentOwnerBalanceWallet);
                    }
                    passengerUser.getPassengerProperty().getBalanceWallet()
                            .setTotalBalance(currentPassengerWalletBalance);
                    booking.getBookingDeposits()
                            .forEach(d -> d.getDeposit().setStatus(DepositStatus.PAID.name()));
                    break;

            }
            if (b.getHomestayType().equalsIgnoreCase(HomestayType.BLOC.name())) {
                blocHomestayOwners.forEach(landlordUser -> {
                    mailService.informBookingToLandlord(landlordUser.getUsername(),
                            passengerUser.getUsername(),
                            booking.getCreatedDate(), landlordUser.getEmail(), HomestayType.BLOC.name(),
                            booking.getBookingHomestays().size(),
                            homestaysInBloc.get(0).getBloc().getName());
                });
            } else {
                homestayOwners.forEach(landlordUser -> {
                    mailService.informBookingToLandlord(landlordUser.getUsername(), passengerUser.getUsername(),
                            booking.getCreatedDate(), landlordUser.getEmail(), HomestayType.HOMESTAY.name(), 0,
                            "");
                });
            }
        }

        booking.setStatus(BookingStatus.PENDING.name());

        return booking;
    }

    private Long getLandlordCommission(Long totalBookingPrice) {
        return (totalBookingPrice * 5) / 100;
    }

    private Long getBookingDeposit(Long totalBookingPrice) {
        return (totalBookingPrice * 20) / 100;
    }

}
