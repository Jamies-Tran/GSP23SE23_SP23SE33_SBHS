package com.sbhs.swm.implement;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sbhs.swm.dto.request.BookingBlocHomestayRequestDto;
import com.sbhs.swm.dto.request.BookingHomestayRequestDto;
import com.sbhs.swm.dto.request.BookingHomestayUpdateRequestDto;
import com.sbhs.swm.dto.request.BookingUpdateRequestDto;
import com.sbhs.swm.dto.request.BookingBlocRequestDto;
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
import com.sbhs.swm.models.BookingShareCode;
import com.sbhs.swm.models.Homestay;
import com.sbhs.swm.models.HomestayService;
import com.sbhs.swm.models.LandlordCommission;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.models.status.BookingShareCodeStatus;
import com.sbhs.swm.models.status.BookingStatus;
import com.sbhs.swm.models.status.DepositStatus;
import com.sbhs.swm.models.type.CommissionType;
import com.sbhs.swm.models.type.HomestayType;
import com.sbhs.swm.models.type.PaymentMethod;
import com.sbhs.swm.repositories.DepositRepo;
import com.sbhs.swm.repositories.HomestayServiceRepo;
import com.sbhs.swm.repositories.BookingHomestayRepo;
import com.sbhs.swm.repositories.BookingRepo;
import com.sbhs.swm.repositories.BookingServiceRepo;
import com.sbhs.swm.repositories.BookingShareCodeRepo;
import com.sbhs.swm.repositories.LandlordCommissionRepo;
import com.sbhs.swm.services.IBookingService;
import com.sbhs.swm.services.IHomestayService;
import com.sbhs.swm.services.IMailService;
import com.sbhs.swm.services.IUserService;
import com.sbhs.swm.util.BookingDateValidationString;
import com.sbhs.swm.util.BookingDateValidationUtil;
import com.sbhs.swm.util.DateTimeUtil;

@Service
public class BookingService implements IBookingService {

    @Autowired
    private LandlordCommissionRepo landlordCommissionRepo;

    @Autowired
    private BookingRepo bookingRepo;

    @Autowired
    private BookingHomestayRepo bookingHomestayRepo;

    @Autowired
    private DepositRepo depositRepo;

    @Autowired
    private BookingServiceRepo bookingHomestayServiceRepo;

    @Autowired
    private HomestayServiceRepo homestayServiceRepo;

    @Autowired
    private IUserService userService;

    @Autowired
    private IHomestayService homestayService;

    @Autowired
    private IMailService mailService;

    @Autowired
    private DateTimeUtil dateFormatUtil;

    @Autowired
    private BookingDateValidationUtil bookingDateValidationUtil;

    @Autowired
    private BookingShareCodeRepo bookingShareCodeRepo;

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
    public List<Homestay> getAvailableHomestayListFromBloc(String blocName, String bookingStart, String bookingEnd) {
        BlocHomestay bloc = homestayService.findBlocHomestayByName(blocName);
        List<Homestay> availableHomestays = new ArrayList<>();
        for (Homestay h : bloc.getHomestays()) {
            if (h.getBookingHomestays() != null && !h.getBookingHomestays().isEmpty()) {
                for (BookingHomestay b : h.getBookingHomestays()) {
                    if (!b.getBooking().getStatus().equalsIgnoreCase(BookingStatus.SAVED.name())) {
                        String validateBookingDateString = bookingDateValidationUtil.bookingValidateString(bookingStart,
                                bookingEnd, b);
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

                    } else {
                        availableHomestays.add(h);
                    }
                }
            } else {
                availableHomestays.add(h);
            }

        }
        return availableHomestays;
    }

    @Override
    @Transactional
    public Booking createBookingByPassenger(String homestayType, String bookingFrom, String bookingTo) {
        SwmUser user = userService.authenticatedUser();
        StringBuilder bookingCodeBuilder = new StringBuilder();
        Random random = new Random();
        int randomNumber = random.nextInt(900000) + 1000000;
        bookingCodeBuilder.append("BOOK").append(randomNumber);
        if (user.getPassengerProperty().getBookings().stream()
                .anyMatch(b -> b.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name())
                        && b.getHomestayType().equalsIgnoreCase(homestayType))) {
            Booking existedSavedBooking = user.getPassengerProperty().getBookings().stream()
                    .filter(b -> b.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name())).findFirst().get();
            existedSavedBooking.setBookingFrom(bookingFrom);
            existedSavedBooking.setBookingTo(bookingTo);
            return existedSavedBooking;
        }
        Booking booking = new Booking();
        booking.setCode(bookingCodeBuilder.toString());
        booking.setPassenger(user.getPassengerProperty());
        booking.setStatus(BookingStatus.SAVED.name());
        booking.setHomestayType(homestayType.toUpperCase());
        booking.setBookingFrom(bookingFrom);
        booking.setBookingTo(bookingTo);
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
                .filter(b -> b.getStatus()
                        .equalsIgnoreCase(BookingStatus.SAVED.name())
                        && b.getHomestayType().equalsIgnoreCase(HomestayType.HOMESTAY.name()))
                .findFirst()
                .orElse(null);

        BookingHomestay bookingHomestay = new BookingHomestay();
        bookingHomestay.setPaymentMethod(bookingHomestayRequest.getPaymentMethod());
        Homestay homestayBooking = homestayService.findHomestayByName(bookingHomestayRequest.getHomestayName());

        List<HomestayService> homestayServiceBookingList = homestayBooking.getHomestayServices().stream()
                .filter(s -> bookingHomestayRequest.getHomestayServiceList().contains(s.getName()))
                .collect(Collectors.toList());
        if (bookingHomestayRepo.findBookingHomestayById(userSaveBooking.getId(), homestayBooking.getId()).isPresent()) {
            Long totalSavedBookingServicePrice = 0L;
            BookingHomestay savedBooking = bookingHomestayRepo
                    .findBookingHomestayById(userSaveBooking.getId(), homestayBooking.getId()).get();
            for (BookingHomestayService s : savedBooking.getBooking().getBookingHomestayServices()) {
                totalSavedBookingServicePrice = totalSavedBookingServicePrice + s.getTotalServicePrice();
            }
            Long currentTotalBookingPrice = userSaveBooking.getTotalBookingPrice() - savedBooking.getTotalBookingPrice()
                    - totalSavedBookingServicePrice;
            userSaveBooking
                    .setTotalBookingPrice(currentTotalBookingPrice);

            bookingHomestayServiceRepo.deleteBookingHomestayService(userSaveBooking.getId());

            bookingHomestayRepo.delete(savedBooking);

        }
        List<BookingHomestayService> bookingHomestayServiceList = new ArrayList<>();

        Long totalBookingAndServicePrice = 0L;
        Long currentBookingTotalPrice = userSaveBooking.getTotalBookingPrice();
        Long currentBookingTotalDeposit = userSaveBooking.getTotalBookingDeposit();

        for (HomestayService s : homestayServiceBookingList) {

            BookingHomestayService bookingHomestayService = new BookingHomestayService();
            bookingHomestayService.setHomestayService(s);
            bookingHomestayService.setBooking(userSaveBooking);
            bookingHomestayService.setTotalServicePrice(s.getPrice());
            bookingHomestayService.setHomestayName(bookingHomestayRequest.getHomestayName());
            bookingHomestayServiceList.add(bookingHomestayService);
        }

        totalBookingAndServicePrice = bookingHomestayRequest.getTotalBookingPrice()
                + bookingHomestayRequest.getTotalServicePrice();
        currentBookingTotalPrice = currentBookingTotalPrice + totalBookingAndServicePrice;
        if (passengerUser.getPassengerProperty().getBalanceWallet().getTotalBalance() < currentBookingTotalPrice
                && bookingHomestayRequest.getPaymentMethod().equalsIgnoreCase(PaymentMethod.SWM_WALLET.name())) {
            throw new InvalidException("You don't have enough balance.");
        }
        homestayBooking.setBookingHomestays(List.of(bookingHomestay));
        userSaveBooking.setBookingHomestays(List.of(bookingHomestay));
        userSaveBooking.setBookingHomestayServices(bookingHomestayServiceList);
        userSaveBooking.setTotalBookingPrice(currentBookingTotalPrice);
        switch (PaymentMethod.valueOf(bookingHomestayRequest.getPaymentMethod().toUpperCase())) {
            case SWM_WALLET:

                Long paidDeposit = this.getBookingDeposit(totalBookingAndServicePrice);
                Long unpaidDeposit = totalBookingAndServicePrice - paidDeposit;
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
                SwmUser landlordUser = homestayBooking.getLandlord().getUser();
                Long currentLandlordWalletBalance = landlordUser.getLandlordProperty().getBalanceWallet()
                        .getTotalBalance();
                Long landlordTotalCommission = this.getLandlordCommission(userSaveBooking.getTotalBookingPrice());
                if (currentLandlordWalletBalance < landlordTotalCommission) {
                    throw new InvalidException("Cash payment is not available right now");
                }

                break;
        }

        bookingHomestay.setTotalBookingPrice(bookingHomestayRequest.getTotalBookingPrice());

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
    public Booking submitBookingForHomestayByPassenger(Long bookingId) {
        Booking booking = this.findBookingById(bookingId);
        StringBuilder shareCodeBuilder = new StringBuilder();
        shareCodeBuilder.append("SHARED").append(booking.getBookingFrom().split("-")[2])
                .append(booking.getBookingTo().split("-")[2])
                .append(booking.getCode().subSequence(4, booking.getCode().length() - 1));
        if (!booking.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name())) {
            throw new InvalidException("booking have been submitted");
        }

        SwmUser passengerUser = booking.getPassenger().getUser();
        BookingShareCode bookingShareCode = new BookingShareCode();
        bookingShareCode.setBooking(booking);
        bookingShareCode.setCreatedBy(passengerUser.getUsername());
        bookingShareCode.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
        bookingShareCode.setStatus(BookingShareCodeStatus.UNUSED.name());
        bookingShareCode.setShareCode(shareCodeBuilder.toString());
        bookingShareCodeRepo.save(bookingShareCode);
        Long currentPassengerWalletBalance = passengerUser.getPassengerProperty().getBalanceWallet()
                .getTotalBalance();
        List<Homestay> homestays = booking.getBookingHomestays().stream().map(b -> b.getHomestay())
                .collect(Collectors.toList());
        List<SwmUser> homestayOwners = homestays.stream().map(b -> b.getLandlord().getUser())
                .collect(Collectors.toList());
        for (BookingHomestay b : booking.getBookingHomestays()) {
            switch (PaymentMethod.valueOf(b.getPaymentMethod().toUpperCase())) {
                case CASH:
                    List<LandlordCommission> landlordCommissionList = new ArrayList<>();
                    for (Homestay h : homestays) {
                        SwmUser landlordUser = h.getLandlord().getUser();
                        Long landlordTotalCommission = 0L;
                        Long currentLandlordWalletBalance = landlordUser.getLandlordProperty()
                                .getBalanceWallet()
                                .getTotalBalance();

                        landlordTotalCommission = landlordTotalCommission
                                + this.getLandlordCommission(b.getTotalBookingPrice());
                        Long newLandlordWalletBalance = currentLandlordWalletBalance -
                                landlordTotalCommission;
                        landlordUser.getLandlordProperty().getBalanceWallet()
                                .setTotalBalance(newLandlordWalletBalance);
                        LandlordCommission landlordCommission = new LandlordCommission();
                        landlordCommission.setCommission(landlordTotalCommission);
                        landlordCommission.setCommissionType(CommissionType.PAID_COMMISSION.name());
                        landlordCommission.setLandlordWallet(
                                landlordUser.getLandlordProperty().getBalanceWallet().getLandlordWallet());
                        landlordUser.getLandlordProperty().getBalanceWallet().getLandlordWallet()
                                .setLandlordCommissions(List.of(landlordCommission));
                        landlordCommission.setCreatedBy(landlordUser.getUsername());
                        landlordCommission.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
                        landlordCommissionList.add(landlordCommission);
                        landlordCommissionRepo.saveAll(landlordCommissionList);
                        if (landlordUser.getLandlordProperty().getBalanceWallet()
                                .getTotalBalance() <= 50000) {
                            mailService.lowBalanceInformToLandlord(landlordUser.getUsername());
                        }
                    }

                    break;
                case SWM_WALLET:

                    // cộng tiền cọc(deposit) vào tk landlord
                    SwmUser owner = null;
                    Long currentOwnerBalanceWallet = null;
                    for (BookingDeposit bookingDeposit : booking.getBookingDeposits()) {
                        if (bookingDeposit.getDeposit().getStatus()
                                .equalsIgnoreCase(DepositStatus.UNPAID.name())) {
                            currentPassengerWalletBalance = currentPassengerWalletBalance
                                    - bookingDeposit.getUnpaidAmount();
                        }

                        Homestay depositForHomestay = homestayService
                                .findHomestayByName(bookingDeposit.getDepositForHomestay());
                        owner = depositForHomestay.getLandlord().getUser();
                        currentOwnerBalanceWallet = owner.getLandlordProperty().getBalanceWallet()
                                .getTotalBalance();
                        currentOwnerBalanceWallet = currentOwnerBalanceWallet
                                + bookingDeposit.getPaidAmount();
                        owner.getLandlordProperty().getBalanceWallet()
                                .setTotalBalance(currentOwnerBalanceWallet);
                        bookingDeposit.getDeposit().setStatus(DepositStatus.PAID.name());

                    }
                    passengerUser.getPassengerProperty().getBalanceWallet()
                            .setTotalBalance(currentPassengerWalletBalance);

                    break;

            }
        }
        homestayOwners.forEach(landlordUser -> {
            mailService.informBookingToLandlord(landlordUser.getUsername(), passengerUser.getUsername(),
                    booking.getCreatedDate(), landlordUser.getEmail(), HomestayType.HOMESTAY.name(), 0,
                    "");
        });

        booking.setStatus(BookingStatus.PENDING.name());

        return booking;
    }

    @Override
    @Transactional
    public Booking submitBookingForBlocByPassenger(Long bookingId, String paymentMethod) {
        Booking booking = this.findBookingById(bookingId);
        if (!booking.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name())) {
            throw new InvalidException("booking have been submitted");
        }
        SwmUser passengerUser = booking.getPassenger().getUser();
        booking.getBookingHomestays().forEach(b -> b.setPaymentMethod(paymentMethod));
        Long currentPassengerWalletBalance = passengerUser.getPassengerProperty().getBalanceWallet()
                .getTotalBalance();
        List<Homestay> homestaysInBloc = booking.getBookingHomestays().stream().map(b -> b.getHomestay())
                .collect(Collectors.toList());
        BlocHomestay bloc = homestayService
                .findBlocHomestayByName(homestaysInBloc.stream().findFirst().get().getBloc().getName());
        SwmUser landlordUser = bloc.getLandlord().getUser();

        switch (PaymentMethod.valueOf(paymentMethod.toUpperCase())) {
            case CASH:

                Long currentLandlordWalletBalance = landlordUser.getLandlordProperty().getBalanceWallet()
                        .getTotalBalance();
                Long landlordTotalCommission = this
                        .getLandlordCommission(booking.getTotalBookingPrice());
                if (currentLandlordWalletBalance < landlordTotalCommission) {
                    throw new InvalidException("Cash payment is not available right now");
                }

                Long newLandlordWalletBalance = currentLandlordWalletBalance -
                        landlordTotalCommission;
                landlordUser.getLandlordProperty().getBalanceWallet()
                        .setTotalBalance(newLandlordWalletBalance);
                LandlordCommission landlordCommission = new LandlordCommission();
                landlordCommission.setCommission(landlordTotalCommission);
                landlordCommission.setCommissionType(CommissionType.PAID_COMMISSION.name());
                landlordCommission.setLandlordWallet(
                        landlordUser.getLandlordProperty().getBalanceWallet().getLandlordWallet());
                landlordUser.getLandlordProperty().getBalanceWallet().getLandlordWallet()
                        .setLandlordCommissions(List.of(landlordCommission));
                landlordCommission.setCreatedBy(landlordUser.getUsername());
                landlordCommission.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
                landlordCommissionRepo.save(landlordCommission);
                if (landlordUser.getLandlordProperty().getBalanceWallet()
                        .getTotalBalance() <= 50000) {
                    mailService.lowBalanceInformToLandlord(landlordUser.getUsername());
                }

                break;
            case SWM_WALLET:

                // cộng tiền cọc(deposit) vào tk landlord
                SwmUser owner = null;
                Long currentOwnerBalanceWallet = null;

                Long currentBookingTotalPrice = booking.getTotalBookingPrice();
                if (passengerUser.getPassengerProperty().getBalanceWallet()
                        .getTotalBalance() < currentBookingTotalPrice) {
                    throw new InvalidException(
                            "You don't have enough balance. Please add more or choose pay by cash.");
                }
                Long paidDeposit = this.getBookingDeposit(currentBookingTotalPrice);
                Long unpaidDeposit = currentBookingTotalPrice - paidDeposit;
                booking.setTotalBookingDeposit(paidDeposit);
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
                bookingDeposit.setDepositForHomestay(booking.getBloc().getName());
                bookingDeposit.setBooking(booking);
                bookingDeposit.setDeposit(deposit);
                booking.setBookingDeposits(List.of(bookingDeposit));
                depositRepo.save(deposit);

                if (bookingDeposit.getDeposit().getStatus()
                        .equalsIgnoreCase(DepositStatus.UNPAID.name())) {
                    currentPassengerWalletBalance = currentPassengerWalletBalance
                            - bookingDeposit.getUnpaidAmount();
                }

                BlocHomestay depositForHomestay = homestayService
                        .findBlocHomestayByName(bookingDeposit.getDepositForHomestay());
                owner = depositForHomestay.getLandlord().getUser();
                currentOwnerBalanceWallet = owner.getLandlordProperty().getBalanceWallet()
                        .getTotalBalance();
                currentOwnerBalanceWallet = currentOwnerBalanceWallet
                        + bookingDeposit.getPaidAmount();
                owner.getLandlordProperty().getBalanceWallet()
                        .setTotalBalance(currentOwnerBalanceWallet);
                bookingDeposit.getDeposit().setStatus(DepositStatus.PAID.name());
                passengerUser.getPassengerProperty().getBalanceWallet()
                        .setTotalBalance(currentPassengerWalletBalance);

                break;

        }
        mailService.informBookingToLandlord(landlordUser.getUsername(),
                passengerUser.getUsername(),
                booking.getCreatedDate(), landlordUser.getEmail(), HomestayType.BLOC.name(),
                booking.getBookingHomestays().size(),
                homestaysInBloc.stream().findFirst().get().getBloc().getName());

        booking.setStatus(BookingStatus.PENDING.name());

        return booking;
    }

    private Long getLandlordCommission(Long totalBookingPrice) {
        return (totalBookingPrice * 5) / 100;
    }

    private Long getBookingDeposit(Long totalBookingPrice) {
        return (totalBookingPrice * 20) / 100;
    }

    @Override
    @Transactional
    public List<BookingHomestay> createSaveBookingForBloc(BookingBlocHomestayRequestDto bookingBlocHomestayRequest) {
        SwmUser passengerUser = userService.authenticatedUser();
        Booking userSaveBooking = passengerUser.getPassengerProperty().getBookings().stream()
                .filter(b -> b.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name())
                        && b.getHomestayType().equalsIgnoreCase(HomestayType.BLOC.name()))
                .findFirst()
                .orElseThrow(() -> new NotFoundException("user didn't create any booking"));

        List<BookingHomestay> bookingHomestayList = new ArrayList<>();

        Long currentBookingTotalPrice = userSaveBooking.getTotalBookingPrice();
        // Long currentBookingTotalDeposit = userSaveBooking.getTotalBookingDeposit();
        currentBookingTotalPrice = currentBookingTotalPrice + bookingBlocHomestayRequest.getTotalBookingPrice()
                + bookingBlocHomestayRequest.getTotalServicePrice();

        // if (passengerUser.getPassengerProperty().getBalanceWallet().getTotalBalance()
        // < currentBookingTotalPrice
        // &&
        // bookingBlocHomestayRequest.getPaymentMethod().equalsIgnoreCase(PaymentMethod.SWM_WALLET.name()))
        // {
        // throw new InvalidException("You don't have enough balance. Please add more or
        // choose pay by cash.");
        // }
        for (BookingBlocRequestDto bookingHomestayRequest : bookingBlocHomestayRequest.getBookingRequestList()) {
            BookingHomestay bookingHomestay = new BookingHomestay();
            Homestay homestayBooking = homestayService.findHomestayByName(bookingHomestayRequest.getHomestayName());
            bookingHomestay.setPaymentMethod(bookingBlocHomestayRequest.getPaymentMethod());
            homestayBooking.setBookingHomestays(List.of(bookingHomestay));
            userSaveBooking.setBookingHomestays(List.of(bookingHomestay));

            bookingHomestay.setTotalBookingPrice(bookingHomestayRequest.getTotalBookingPrice());
            bookingHomestay.setTotalReservation(bookingHomestayRequest.getTotalReservation());
            bookingHomestay.setHomestay(homestayBooking);
            bookingHomestay.setBooking(userSaveBooking);
            bookingHomestayList.add(bookingHomestay);
        }
        BlocHomestay bloc = homestayService.findBlocHomestayByName(bookingBlocHomestayRequest.getBlocName());
        userSaveBooking.setBloc(bloc);
        bloc.setBooking(userSaveBooking);
        List<BookingHomestayService> bookingHomestayServiceList = new ArrayList<>();
        List<HomestayService> homestayServiceBookingList = bloc.getHomestayServices().stream()
                .filter(s -> bookingBlocHomestayRequest.getHomestayServiceNameList().contains(s.getName()))
                .collect(Collectors.toList());

        for (HomestayService s : homestayServiceBookingList) {

            BookingHomestayService bookingHomestayService = new BookingHomestayService();
            bookingHomestayService.setHomestayService(s);
            bookingHomestayService.setBooking(userSaveBooking);
            bookingHomestayService.setTotalServicePrice(s.getPrice());
            bookingHomestayServiceList.add(bookingHomestayService);
        }
        userSaveBooking.setTotalBookingPrice(currentBookingTotalPrice);
        userSaveBooking.setBookingHomestayServices(bookingHomestayServiceList);

        // BlocHomestay blocHomestayBooking = homestayService
        // .findBlocHomestayByName(bookingBlocHomestayRequest.getBlocName());
        // switch
        // (PaymentMethod.valueOf(bookingBlocHomestayRequest.getPaymentMethod().toUpperCase()))
        // {
        // case SWM_WALLET:

        // Long paidDeposit = this.getBookingDeposit(currentBookingTotalPrice);
        // Long unpaidDeposit = currentBookingTotalPrice - paidDeposit;
        // currentBookingTotalDeposit = currentBookingTotalDeposit + paidDeposit;
        // userSaveBooking.setTotalBookingDeposit(currentBookingTotalDeposit);
        // Deposit deposit = new Deposit();

        // BookingDeposit bookingDeposit = new BookingDeposit();
        // deposit.setBookingDeposits(List.of(bookingDeposit));
        // deposit.setCreatedBy(passengerUser.getUsername());
        // deposit.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
        // deposit.setPassengerWallet(
        // passengerUser.getPassengerProperty().getBalanceWallet().getPassengerWallet());
        // passengerUser.getPassengerProperty().getBalanceWallet().getPassengerWallet()
        // .setDeposits(List.of(deposit));

        // bookingDeposit.setPaidAmount(paidDeposit);
        // bookingDeposit.setUnpaidAmount(unpaidDeposit);
        // bookingDeposit.setDepositForHomestay(blocHomestayBooking.getName());
        // bookingDeposit.setBooking(userSaveBooking);
        // bookingDeposit.setDeposit(deposit);
        // userSaveBooking.setBookingDeposits(List.of(bookingDeposit));
        // depositRepo.save(deposit);

        // break;
        // case CASH:
        // SwmUser landlordUser = blocHomestayBooking.getLandlord().getUser();
        // Long currentLandlordWalletBalance =
        // landlordUser.getLandlordProperty().getBalanceWallet()
        // .getTotalBalance();
        // Long landlordTotalCommission =
        // this.getLandlordCommission(userSaveBooking.getTotalBookingPrice());
        // if (currentLandlordWalletBalance < landlordTotalCommission) {
        // throw new InvalidException("Cash payment is not available right now");
        // }
        // break;
        // }

        List<BookingHomestay> savedBookingHomestayList = bookingHomestayRepo.saveAll(bookingHomestayList);

        return savedBookingHomestayList;
    }

    @Override
    public boolean checkValidBookingForHomestay(String homestayName, String bookingStart, String bookingEnd,
            int totalReservation) {

        Homestay homestay = homestayService.findHomestayByName(homestayName);
        int totalCurrentHomestayCapacity = homestay.getAvailableRooms() * homestay.getRoomCapacity();
        List<BookingHomestay> bookingHomestays = homestay.getBookingHomestays().stream()
                .filter(b -> !b.getBooking().getStatus().equalsIgnoreCase(BookingStatus.SAVED.name()))
                .collect(Collectors.toList());
        for (BookingHomestay b : bookingHomestays) {
            String getBookingValidationgString = bookingDateValidationUtil.bookingValidateString(bookingStart,
                    bookingEnd, b);
            switch (BookingDateValidationString.valueOf(getBookingValidationgString)) {
                case INVALID:
                    return false;
                case CURRENT_END_ON_BOOKED_END:

                    return false;
                case CURRENT_START_ON_BOOKED_END:
                    break;
                case CURRENT_START_ON_BOOKED_START:

                    return false;
                case ON_BOOKING_PERIOD:

                    return false;
                case OK:
                    break;
            }
        }
        if (totalCurrentHomestayCapacity < totalReservation) {
            return false;
        }

        return true;
    }

    @Override
    public BookingHomestay getBookingHomestayByHomestayId(Long homestayId) {
        SwmUser user = userService.authenticatedUser();
        if (user.getPassengerProperty().getBookings().stream()
                .filter(b -> b.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name()))
                .findAny().isPresent()) {
            Booking booking = user.getPassengerProperty().getBookings().stream()
                    .filter(b -> b.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name()))
                    .findAny().get();
            BookingHomestay bookingHomestay = bookingHomestayRepo.findBookingHomestayById(booking.getId(), homestayId)
                    .orNull();
            return bookingHomestay;
        }
        return null;
    }

    @Override
    @Transactional
    public void deleteBookingHomestay(Long bookingId, Long homestayId) {
        Booking booking = this.findBookingById(bookingId);
        if (!booking.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name())) {
            throw new InvalidException("Can't delete this booking.");
        }
        BookingHomestay bookingHomestay = bookingHomestayRepo.findBookingHomestayById(bookingId, homestayId).get();
        Long currentBookingTotalPrice = booking.getTotalBookingPrice();
        currentBookingTotalPrice = currentBookingTotalPrice - bookingHomestay.getTotalBookingPrice();
        booking.setTotalBookingPrice(currentBookingTotalPrice);
        bookingHomestayRepo.deleteBookingHomestayById(bookingId, homestayId);
        bookingHomestayServiceRepo.deleteBookingHomestayService(bookingId);
    }

    @Override
    @Transactional
    public void deleteBooking(Long bookingId) {
        Booking booking = this.findBookingById(bookingId);
        if (booking.getBloc() != null) {
            booking.getBloc().setBooking(null);
        }
        if (!booking.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name())) {
            throw new InvalidException("Can't delete this booking.");
        }

        bookingRepo.deleteById(bookingId);

    }

    @Override
    @Transactional
    public Booking updateSavedBooking(BookingUpdateRequestDto newBooking, Long bookingId) {
        Booking booking = this.findBookingById(bookingId);
        SwmUser user = userService.authenticatedUser();
        int duration = dateFormatUtil.calculateDurationBooking(newBooking.getBookingFrom(),
                newBooking.getBookingTo());
        Long totalBookingPrice = 0L;
        Long totalServicePrice = 0L;
        for (BookingHomestayUpdateRequestDto b : newBooking.getBookingHomestays()) {
            Homestay homestay = homestayService.findHomestayByName(b.getHomestay().getName());
            BookingHomestay bookingHomestay = bookingHomestayRepo.findBookingHomestayById(bookingId, homestay.getId())
                    .get();
            Long newTotalBookingPrice = homestay.getPrice() * duration;
            bookingHomestay.setTotalBookingPrice(newTotalBookingPrice);
            totalBookingPrice = totalBookingPrice + newTotalBookingPrice;
        }
        for (BookingHomestayService s : booking.getBookingHomestayServices()) {
            totalServicePrice = totalServicePrice + s.getTotalServicePrice();
        }
        totalBookingPrice = totalBookingPrice + totalServicePrice;
        booking.setTotalBookingPrice(totalBookingPrice);
        booking.setBookingFrom(newBooking.getBookingFrom());
        booking.setBookingTo(newBooking.getBookingTo());
        booking.setUpdatedBy(user.getUsername());
        booking.setUpdatedDate(dateFormatUtil.formatDateTimeNowToString());
        return booking;
    }

    @Override
    @Transactional
    public Booking updateSavedBookingServices(List<String> serviceNameList, String homestayName, Long bookingId) {
        Booking booking = this.findBookingById(bookingId);
        // List<HomestayService> homestayServiceList = serviceNameList.stream()
        // .map(s ->
        // homestayServiceRepo.findHomestayServiceByServiceNameAndHomestayName(s,
        // homestayName).get())
        // .collect(Collectors.toList());
        List<HomestayService> homestayServiceList = serviceNameList.stream()
                .map(s -> homestayServiceRepo.findHomestayServiceByName(s).get())
                .collect(Collectors.toList());
        homestayServiceList = homestayServiceList.stream().filter(
                s -> (s.getHomestay() != null && s.getHomestay().getName().equals(homestayName))
                        || (s.getBloc() != null && s.getBloc().getName().equals(homestayName)))
                .collect(Collectors.toList());

        bookingHomestayServiceRepo.deleteBookingHomestayService(bookingId);
        List<BookingHomestayService> bookingHomestayServiceList = new ArrayList<>();
        Long newServicePrice = 0L;
        Long currentHomestayBookingPrice = 0L;
        for (HomestayService s : homestayServiceList) {
            newServicePrice = newServicePrice + s.getPrice();
            BookingHomestayService bookingHomestayService = new BookingHomestayService();
            bookingHomestayService.setHomestayName(homestayName);
            bookingHomestayService.setTotalServicePrice(s.getPrice());
            bookingHomestayService.setHomestayService(s);
            bookingHomestayService.setBooking(booking);
            bookingHomestayServiceList.add(bookingHomestayService);
        }
        for (BookingHomestay b : booking.getBookingHomestays()) {
            currentHomestayBookingPrice = currentHomestayBookingPrice + b.getTotalBookingPrice();
        }
        Long newTotalBookingPrice = newServicePrice + currentHomestayBookingPrice;
        booking.setTotalBookingPrice(newTotalBookingPrice);
        booking.setBookingHomestayServices(bookingHomestayServiceList);
        return booking;
    }

    @Override
    public Booking findBookingSavedBlocHomestayType() {
        SwmUser user = userService.authenticatedUser();
        Booking booking = user.getPassengerProperty().getBookings().stream()
                .filter(b -> b.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name())
                        && b.getHomestayType().equalsIgnoreCase(HomestayType.BLOC.name()))
                .findFirst().orElseThrow(() -> new NotFoundException("Can't find booking"));
        return booking;
    }

    @Override
    @Transactional
    public void addHomestayInBlocToBooking(String homestayName, Long bookingId, String paymentMethod) {
        Booking booking = findBookingById(bookingId);
        Homestay homestay = homestayService.findHomestayByName(homestayName);
        BookingHomestay bookingHomestay = new BookingHomestay();

        int duration = dateFormatUtil.calculateDurationBooking(booking.getBookingFrom(), booking.getBookingTo());
        Long totalBookingHomestayPrice = homestay.getPrice() * duration;
        Long totalBookingPrice = booking.getTotalBookingPrice();
        bookingHomestay.setTotalBookingPrice(totalBookingHomestayPrice);
        bookingHomestay.setBooking(booking);
        bookingHomestay.setHomestay(homestay);
        bookingHomestay.setPaymentMethod(paymentMethod);
        bookingHomestay.setTotalReservation(Long.valueOf(homestay.getAvailableRooms()));
        booking.setBookingHomestays(List.of(bookingHomestay));
        bookingHomestayRepo.save(bookingHomestay);
        for (BookingHomestay b : booking.getBookingHomestays()) {
            totalBookingPrice = totalBookingPrice + b.getTotalBookingPrice();
        }
        booking.setTotalBookingPrice(totalBookingPrice);
        homestay.setBookingHomestays(List.of(bookingHomestay));

    }

}
