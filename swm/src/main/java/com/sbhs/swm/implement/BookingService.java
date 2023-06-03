package com.sbhs.swm.implement;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.support.PagedListHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sbhs.swm.dto.request.BookingBlocHomestayRequestDto;
import com.sbhs.swm.dto.request.BookingHomestayRequestDto;
import com.sbhs.swm.dto.request.BookingHomestayUpdateRequestDto;
import com.sbhs.swm.dto.request.BookingUpdateRequestDto;
import com.sbhs.swm.dto.request.FilterBookingRequestDto;
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
import com.sbhs.swm.models.BookingInviteCode;
import com.sbhs.swm.models.Homestay;
import com.sbhs.swm.models.HomestayService;
import com.sbhs.swm.models.Landlord;
import com.sbhs.swm.models.LandlordCommission;
import com.sbhs.swm.models.Passenger;

import com.sbhs.swm.models.Promotion;
import com.sbhs.swm.models.PromotionCampaign;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.models.status.BookingInviteCodeStatus;
import com.sbhs.swm.models.status.BookingStatus;
import com.sbhs.swm.models.status.DepositStatus;
import com.sbhs.swm.models.status.PromotionCampaignStatus;
import com.sbhs.swm.models.status.PromotionStatus;
import com.sbhs.swm.models.type.CommissionType;
import com.sbhs.swm.models.type.HomestayType;
import com.sbhs.swm.models.type.PaymentMethod;
import com.sbhs.swm.repositories.DepositRepo;
import com.sbhs.swm.repositories.HomestayServiceRepo;
import com.sbhs.swm.repositories.BookingHomestayRepo;
import com.sbhs.swm.repositories.BookingRepo;
import com.sbhs.swm.repositories.BookingServiceRepo;
import com.sbhs.swm.repositories.BookingInviteCodeRepo;
import com.sbhs.swm.repositories.LandlordCommissionRepo;

import com.sbhs.swm.repositories.PromotionRepo;
import com.sbhs.swm.services.IBookingService;
import com.sbhs.swm.services.IHomestayService;
import com.sbhs.swm.services.IMailService;
import com.sbhs.swm.services.IUserService;
import com.sbhs.swm.util.BookingDateValidationString;
import com.sbhs.swm.util.BookingDateValidationUtil;
import com.sbhs.swm.util.DateTimeUtil;

@Service
public class BookingService implements IBookingService {

    private int HOMESTAY_DISCOUNT_AMOUNT = 10;

    private int BLOC_DISCOUNT_AMOUNT = 15;

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
    private PromotionRepo promotionRepo;

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
    private BookingInviteCodeRepo bookingShareCodeRepo;

    // @Override
    // public List<Booking> findBookingsByUsernameAndStatus(String status) {
    // SwmUser user = userService.authenticatedUser();
    // List<Booking> bookings =
    // bookingRepo.findBookingByUsernameAndStatus(user.getUsername(), status);

    // return bookings;
    // }

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
        boolean isAvailable = false;
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
                                // availableHomestays.add(h);
                                isAvailable = true;
                                break;
                            case CURRENT_START_ON_BOOKED_START:
                                break;
                            case ON_BOOKING_PERIOD:
                                break;
                            case OK:
                                // availableHomestays.add(h);
                                isAvailable = true;
                                break;
                        }

                    } else {
                        // availableHomestays.add(h);
                        isAvailable = true;
                    }

                }
            } else {
                isAvailable = true;
            }
            if (isAvailable) {
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
        // Long currentBookingTotalDeposit = userSaveBooking.getTotalBookingDeposit();

        for (HomestayService s : homestayServiceBookingList) {

            BookingHomestayService bookingHomestayService = new BookingHomestayService();
            bookingHomestayService.setCreatedBy(passengerUser.getUsername());
            bookingHomestayService.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
            bookingHomestayService.setHomestayService(s);
            bookingHomestayService.setBooking(userSaveBooking);
            bookingHomestayService.setTotalServicePrice(s.getPrice());
            bookingHomestayService.setHomestayName(bookingHomestayRequest.getHomestayName());
            bookingHomestayServiceList.add(bookingHomestayService);
        }

        totalBookingAndServicePrice = bookingHomestayRequest.getTotalBookingPrice()
                + bookingHomestayRequest.getTotalServicePrice();
        currentBookingTotalPrice = currentBookingTotalPrice + totalBookingAndServicePrice;

        homestayBooking.setBookingHomestays(List.of(bookingHomestay));
        userSaveBooking.setBookingHomestays(List.of(bookingHomestay));
        userSaveBooking.setBookingHomestayServices(bookingHomestayServiceList);
        userSaveBooking.setTotalBookingPrice(currentBookingTotalPrice);
        switch (PaymentMethod.valueOf(bookingHomestayRequest.getPaymentMethod().toUpperCase())) {
            case SWM_WALLET:
                Long totalUnpaidDeposit = 0L;
                Long currentPassengerBalance = passengerUser.getPassengerProperty().getBalanceWallet()
                        .getTotalBalance();

                if (passengerUser.getPassengerProperty().getBalanceWallet().getPassengerWallet()
                        .getDeposits() != null) {
                    for (Deposit d : passengerUser.getPassengerProperty().getBalanceWallet().getPassengerWallet()
                            .getDeposits()) {
                        for (BookingDeposit bd : d.getBookingDeposits()) {
                            if (bd.getStatus().equalsIgnoreCase(DepositStatus.UNPAID.name())) {
                                totalUnpaidDeposit = totalUnpaidDeposit + bd.getUnpaidAmount();
                            }
                        }
                    }
                }
                Long actualBalance = currentPassengerBalance - totalUnpaidDeposit;
                if (actualBalance < currentBookingTotalPrice) {
                    throw new InvalidException("You don't have enough balance.");
                }

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

    // @Override
    // public List<Booking> findBookingsByHomestayNameAndStatus(String
    // bookingStatus, String homestayName) {
    // List<BookingHomestay> bookingHomestays =
    // bookingHomestayRepo.findBookingHomestaysByHomestayName(bookingStatus);
    // List<Booking> bookings = bookingHomestays.stream().map(b -> b.getBooking())
    // .filter(b ->
    // b.getStatus().equalsIgnoreCase(bookingStatus)).collect(Collectors.toList());

    // return bookings;
    // }

    @Override
    @Transactional
    public Booking submitBookingForHomestayByPassenger(Long bookingId) {
        Booking booking = this.findBookingById(bookingId);
        StringBuilder inviteCodeBuilder = new StringBuilder();
        inviteCodeBuilder.append("SHARED").append(booking.getBookingFrom().split("-")[2])
                .append(booking.getBookingTo().split("-")[2])
                .append(booking.getCode().subSequence(4, booking.getCode().length() - 1));
        if (!booking.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name())) {
            throw new InvalidException("booking have been submitted");
        }

        SwmUser passengerUser = booking.getPassenger().getUser();
        BookingInviteCode bookingShareCode = new BookingInviteCode();
        bookingShareCode.setBooking(booking);
        bookingShareCode.setCreatedBy(passengerUser.getUsername());
        bookingShareCode.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
        bookingShareCode.setStatus(BookingInviteCodeStatus.UNUSED.name());
        bookingShareCode.setInviteCode(inviteCodeBuilder.toString());
        booking.setInviteCode(bookingShareCode);
        bookingShareCodeRepo.save(bookingShareCode);

        List<Homestay> homestays = booking.getBookingHomestays().stream().map(b -> b.getHomestay())
                .collect(Collectors.toList());
        List<SwmUser> homestayOwners = homestays.stream().map(b -> b.getLandlord().getUser())
                .collect(Collectors.toList());

        homestayOwners.forEach(landlordUser -> {
            mailService.informBookingToLandlord(landlordUser.getUsername(), passengerUser.getUsername(),
                    booking.getCreatedDate(), landlordUser.getEmail(), HomestayType.HOMESTAY.name(), 0,
                    "");
        });

        booking.setStatus(BookingStatus.PROGRESSING.name());
        booking.getBookingHomestays().forEach(b -> b.setStatus(BookingStatus.PENDING.name()));
        if (booking.getPromotions() != null) {
            Long totalDiscountPrice = 0L;
            for (Promotion p : booking.getPromotions()) {
                totalDiscountPrice = totalDiscountPrice
                        + (booking.getTotalBookingPrice() * p.getDiscountAmount() / 100);
            }
            Long totalBookingPrice = booking.getTotalBookingPrice() - totalDiscountPrice;
            booking.setTotalBookingPrice(totalBookingPrice);
            booking.getPromotions().forEach(p -> p.setStatus(PromotionStatus.USED.name()));
        }

        return booking;
    }

    @Override
    @Transactional
    public Booking submitBookingForBlocByPassenger(Long bookingId, String paymentMethod) {
        Booking booking = this.findBookingById(bookingId);
        StringBuilder shareCodeBuilder = new StringBuilder();
        shareCodeBuilder.append("INVITE").append(booking.getBookingFrom().split("-")[2])
                .append(booking.getBookingTo().split("-")[2])
                .append(booking.getCode().subSequence(4, booking.getCode().length() - 1));
        if (!booking.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name())) {
            throw new InvalidException("booking have been submitted");
        }
        SwmUser passengerUser = booking.getPassenger().getUser();
        Long currentBookingTotalPrice = booking.getTotalBookingPrice();

        switch (PaymentMethod.valueOf(paymentMethod.toUpperCase())) {
            case SWM_WALLET:
                Long totalUnpaidDeposit = 0L;
                Long currentPassengerBalance = passengerUser.getPassengerProperty().getBalanceWallet()
                        .getTotalBalance();

                if (passengerUser.getPassengerProperty().getBalanceWallet().getPassengerWallet()
                        .getDeposits() != null) {
                    for (Deposit d : passengerUser.getPassengerProperty().getBalanceWallet().getPassengerWallet()
                            .getDeposits()) {
                        for (BookingDeposit bd : d.getBookingDeposits()) {
                            if (bd.getStatus().equalsIgnoreCase(DepositStatus.UNPAID.name())) {
                                totalUnpaidDeposit = totalUnpaidDeposit + bd.getUnpaidAmount();
                            }
                        }
                    }
                }
                Long actualBalance = currentPassengerBalance - totalUnpaidDeposit;
                if (actualBalance < currentBookingTotalPrice) {
                    throw new InvalidException("You don't have enough balance.");
                }

                break;
            case CASH:
                SwmUser landlordUser = booking.getBloc().getLandlord().getUser();
                Long currentLandlordWalletBalance = landlordUser.getLandlordProperty().getBalanceWallet()
                        .getTotalBalance();

                Long landlordTotalCommission = this.getLandlordCommission(currentBookingTotalPrice);
                if (currentLandlordWalletBalance < landlordTotalCommission) {
                    throw new InvalidException("Cash payment is not available right now");
                }

                break;
        }
        BookingInviteCode bookingShareCode = new BookingInviteCode();
        bookingShareCode.setBooking(booking);
        bookingShareCode.setCreatedBy(passengerUser.getUsername());
        bookingShareCode.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
        bookingShareCode.setStatus(BookingInviteCodeStatus.UNUSED.name());
        bookingShareCode.setInviteCode(shareCodeBuilder.toString());
        booking.setInviteCode(bookingShareCode);
        passengerUser.getPassengerProperty().setInviteCodes(List.of(bookingShareCode));
        bookingShareCodeRepo.save(bookingShareCode);
        booking.getBookingHomestays().forEach(b -> b.setPaymentMethod(paymentMethod));

        List<Homestay> homestaysInBloc = booking.getBookingHomestays().stream().map(b -> b.getHomestay())
                .collect(Collectors.toList());
        BlocHomestay bloc = homestayService
                .findBlocHomestayByName(homestaysInBloc.stream().findFirst().get().getBloc().getName());
        SwmUser landlordUser = bloc.getLandlord().getUser();
        mailService.informBookingToLandlord(landlordUser.getUsername(),
                passengerUser.getUsername(),
                booking.getCreatedDate(), landlordUser.getEmail(), HomestayType.BLOC.name(),
                booking.getBookingHomestays().size(),
                homestaysInBloc.stream().findFirst().get().getBloc().getName());

        booking.setStatus(BookingStatus.PENDING.name());
        booking.getBookingHomestays().forEach(b -> b.setStatus(BookingStatus.PENDING.name()));

        if (booking.getPromotions() != null) {
            Long totalDiscountPrice = 0L;
            for (Promotion p : booking.getPromotions()) {
                totalDiscountPrice = totalDiscountPrice
                        + (booking.getTotalBookingPrice() * p.getDiscountAmount() / 100);
            }
            Long totalBookingPrice = booking.getTotalBookingPrice() - totalDiscountPrice;
            booking.setTotalBookingPrice(totalBookingPrice);
            booking.getPromotions().forEach(p -> p.setStatus(PromotionStatus.USED.name()));
        }
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

        currentBookingTotalPrice = currentBookingTotalPrice + bookingBlocHomestayRequest.getTotalBookingPrice()
                + bookingBlocHomestayRequest.getTotalServicePrice();

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
        bloc.setBookings(List.of(userSaveBooking));
        List<BookingHomestayService> bookingHomestayServiceList = new ArrayList<>();
        List<HomestayService> homestayServiceBookingList = bloc.getHomestayServices().stream()
                .filter(s -> bookingBlocHomestayRequest.getHomestayServiceNameList().contains(s.getName()))
                .collect(Collectors.toList());

        for (HomestayService s : homestayServiceBookingList) {

            BookingHomestayService bookingHomestayService = new BookingHomestayService();
            bookingHomestayService.setHomestayName(bloc.getName());
            bookingHomestayService.setHomestayService(s);
            bookingHomestayService.setBooking(userSaveBooking);
            bookingHomestayService.setTotalServicePrice(s.getPrice());
            bookingHomestayServiceList.add(bookingHomestayService);
        }
        userSaveBooking.setTotalBookingPrice(currentBookingTotalPrice);
        userSaveBooking.setBookingHomestayServices(bookingHomestayServiceList);
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
    public BookingHomestay getSavedBookingHomestayByHomestayId(Long homestayId) {
        SwmUser user = userService.authenticatedUser();
        if (user.getPassengerProperty().getBookings().stream()
                .filter(b -> b.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name()))
                .findAny().isPresent()) {
            Booking booking = user.getPassengerProperty().getBookings().stream()
                    .filter(b -> b.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name()))
                    .findAny().get();
            BookingHomestay bookingHomestay = bookingHomestayRepo.findBookingHomestayById(booking.getId(), homestayId)
                    .orElse(null);
            return bookingHomestay;
        }
        return null;
    }

    @Override
    @Transactional
    public void deleteBookingHomestay(Long bookingId, Long homestayId) {
        Booking booking = this.findBookingById(bookingId);
        List<BookingHomestayService> bookingHomestayServiceList = booking.getBookingHomestayServices();
        List<HomestayService> serviceList = bookingHomestayServiceList.stream().map(s -> s.getHomestayService())
                .filter(s -> s.getHomestay().getId() == homestayId)
                .collect(Collectors.toList());
        if (!booking.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name())) {
            throw new InvalidException("Can't delete this booking.");
        }
        BookingHomestay bookingHomestay = bookingHomestayRepo.findBookingHomestayById(bookingId, homestayId).get();
        Long currentBookingTotalPrice = booking.getTotalBookingPrice();
        Long currentBookingServiceTotalPrice = 0L;
        for (HomestayService s : serviceList) {
            currentBookingServiceTotalPrice = currentBookingServiceTotalPrice + s.getPrice();
        }
        currentBookingTotalPrice = currentBookingTotalPrice
                - (bookingHomestay.getTotalBookingPrice() + currentBookingServiceTotalPrice);
        booking.setTotalBookingPrice(currentBookingTotalPrice);
        bookingHomestayRepo.deleteBookingHomestayById(bookingId, homestayId);
        serviceList.forEach(s -> bookingHomestayServiceRepo
                .deleteBookingHomestayServiceByBookingIdAndServiceId(bookingId, s.getId()));
    }

    @Override
    @Transactional
    public void deleteBooking(Long bookingId) {
        Booking booking = this.findBookingById(bookingId);
        if (booking.getBloc() != null) {
            booking.getBloc().setBookings(null);
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
        int duration = dateFormatUtil.differenceInDays(newBooking.getBookingFrom(),
                newBooking.getBookingTo());
        Long totalBookingPrice = 0L;
        Long totalServicePrice = 0L;
        Long newTotalBookingPrice = 0L;
        switch (HomestayType.valueOf(booking.getHomestayType().toUpperCase())) {
            case HOMESTAY:
                for (BookingHomestayUpdateRequestDto b : newBooking.getBookingHomestays()) {
                    Homestay homestay = homestayService.findHomestayByName(b.getHomestay().getName());
                    Long currentHomestayPrice = homestay.getPrice();
                    for (PromotionCampaign c : homestay.getCampaigns()) {
                        if (c.getStatus().equalsIgnoreCase(PromotionCampaignStatus.PROGRESSING.name())) {
                            Long discountAmount = currentHomestayPrice * c.getDiscountPercent() / 100;
                            currentHomestayPrice = currentHomestayPrice - discountAmount;
                        }
                    }
                    BookingHomestay bookingHomestay = bookingHomestayRepo
                            .findBookingHomestayById(bookingId, homestay.getId())
                            .get();
                    newTotalBookingPrice = currentHomestayPrice * duration;
                    bookingHomestay.setTotalBookingPrice(newTotalBookingPrice);
                    totalBookingPrice = totalBookingPrice + newTotalBookingPrice;
                }
                break;
            case BLOC:
                for (PromotionCampaign c : booking.getBloc().getCampaigns()) {
                    if (c.getStatus().equalsIgnoreCase(PromotionCampaignStatus.PROGRESSING.name())) {
                        for (BookingHomestayUpdateRequestDto b : newBooking.getBookingHomestays()) {
                            Homestay homestay = homestayService.findHomestayByName(b.getHomestay().getName());
                            Long currentHomestayPrice = homestay.getPrice();
                            Long discountAmount = currentHomestayPrice * c.getDiscountPercent() / 100;
                            currentHomestayPrice = currentHomestayPrice - discountAmount;
                            newTotalBookingPrice = currentHomestayPrice * duration;
                            BookingHomestay bookingHomestay = bookingHomestayRepo
                                    .findBookingHomestayById(booking.getId(), homestay.getId()).get();
                            bookingHomestay.setTotalBookingPrice(newTotalBookingPrice);
                            totalBookingPrice = totalBookingPrice + newTotalBookingPrice;
                        }
                    }
                }
                break;
        }

        // totalBookingPrice = totalBookingPrice + newTotalBookingPrice;
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
    public Booking updateSavedBookingServices(List<Long> serviceIdList, String homestayName, Long bookingId) {
        Booking booking = this.findBookingById(bookingId);

        List<HomestayService> homestayServiceList = serviceIdList.stream()
                .map(s -> homestayServiceRepo.findById(s).get())
                .collect(Collectors.toList());
        homestayServiceList = homestayServiceList.stream().filter(
                s -> (s.getHomestay() != null && s.getHomestay().getName().equals(homestayName))
                        || (s.getBloc() != null && s.getBloc().getName().equals(homestayName)))
                .collect(Collectors.toList());
        bookingHomestayServiceRepo.deleteBookingHomestayServiceByBookingIdAndHomestayName(bookingId, homestayName);
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

        int duration = dateFormatUtil.differenceInDays(booking.getBookingFrom(), booking.getBookingTo());
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

    @Override
    public List<BookingHomestay> getLandlordBookingHomestayList(String homestayName, String status) {
        List<BookingHomestay> bookingHomestayList = bookingHomestayRepo.findBookingHomestayByHomestayNameAndStatus(
                homestayName,
                status);
        return bookingHomestayList;
    }

    @Override
    @Transactional
    public BookingHomestay acceptBookingForHomestay(Long bookingId, Long homestayId) {
        SwmUser landlordUser = userService.authenticatedUser();
        BookingHomestay bookingHomestay = bookingHomestayRepo.findBookingHomestayById(bookingId, homestayId).get();
        Booking booking = bookingHomestay.getBooking();
        SwmUser passengerUser = bookingHomestay.getBooking().getPassenger().getUser();
        // Long totalBookingAndServicePrice =
        // bookingHomestay.getBooking().getTotalBookingPrice();
        Long totalBookingAndServicePrice = 0L;
        totalBookingAndServicePrice = totalBookingAndServicePrice + bookingHomestay.getTotalBookingPrice();
        if (booking.getBookingHomestayServices() != null) {
            for (BookingHomestayService bs : booking.getBookingHomestayServices()) {
                if (bs.getHomestayName().equals(bookingHomestay.getHomestay().getName())) {
                    totalBookingAndServicePrice = totalBookingAndServicePrice + bs.getHomestayService().getPrice();
                }
            }
        }
        Long currentBookingTotalDeposit = bookingHomestay.getBooking().getTotalBookingDeposit();
        switch (PaymentMethod.valueOf(bookingHomestay.getPaymentMethod().toUpperCase())) {
            case SWM_WALLET:
                Long paidDeposit = this.getBookingDeposit(totalBookingAndServicePrice);
                Long unpaidDeposit = totalBookingAndServicePrice - paidDeposit;
                Long currentPassengerBalance = passengerUser.getPassengerProperty().getBalanceWallet().getTotalBalance()
                        - paidDeposit;
                passengerUser.getPassengerProperty().getBalanceWallet().setTotalBalance(currentPassengerBalance);
                passengerUser.setUpdatedBy(passengerUser.getUsername());
                passengerUser.setUpdatedDate(dateFormatUtil.formatDateTimeNowToString());
                currentBookingTotalDeposit = currentBookingTotalDeposit + paidDeposit;
                bookingHomestay.getBooking().setTotalBookingDeposit(currentBookingTotalDeposit);
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
                bookingDeposit.setDepositForHomestay(bookingHomestay.getHomestay().getName());
                bookingDeposit.setBooking(bookingHomestay.getBooking());
                bookingDeposit.setDeposit(deposit);
                bookingHomestay.getBooking().setBookingDeposits(List.of(bookingDeposit));
                depositRepo.save(deposit);
                break;
            case CASH:
                List<LandlordCommission> landlordCommissionList = new ArrayList<>();

                Long landlordTotalCommission = 0L;
                Long currentLandlordWalletBalance = landlordUser.getLandlordProperty()
                        .getBalanceWallet()
                        .getTotalBalance();

                landlordTotalCommission = landlordTotalCommission
                        + this.getLandlordCommission(bookingHomestay.getTotalBookingPrice());
                Long newLandlordWalletBalance = currentLandlordWalletBalance -
                        landlordTotalCommission;
                landlordUser.getLandlordProperty().getBalanceWallet()
                        .setTotalBalance(newLandlordWalletBalance);
                List<LandlordCommission> currentLandlordCommissions = landlordUser.getLandlordProperty()
                        .getBalanceWallet().getLandlordWallet().getLandlordCommissions();
                LandlordCommission landlordCommission = new LandlordCommission();
                landlordCommission.setCommission(landlordTotalCommission);
                landlordCommission.setCommissionType(CommissionType.PAID_COMMISSION.name());
                landlordCommission.setCreatedBy(landlordUser.getUsername());
                landlordCommission.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());

                landlordCommission.setLandlordWallet(
                        landlordUser.getLandlordProperty().getBalanceWallet().getLandlordWallet());
                currentLandlordCommissions.add(landlordCommission);
                landlordUser.getLandlordProperty().getBalanceWallet().getLandlordWallet()
                        .setLandlordCommissions(currentLandlordCommissions);
                landlordCommission.setCreatedBy(landlordUser.getUsername());
                landlordCommission.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
                landlordCommissionList.add(landlordCommission);
                landlordCommissionRepo.saveAll(landlordCommissionList);
                if (landlordUser.getLandlordProperty().getBalanceWallet()
                        .getTotalBalance() <= 50000) {
                    mailService.lowBalanceInformToLandlord(landlordUser.getUsername());
                }

                break;
        }
        bookingHomestay.setStatus(BookingStatus.ACCEPTED.name());
        bookingHomestay.setUpdatedBy(landlordUser.getUsername());
        bookingHomestay.setUpdatedDate(dateFormatUtil.formatDateTimeNowToString());

        mailService.informBookingForHomestayAccepted(bookingHomestay);
        return bookingHomestay;
    }

    @Override
    @Transactional
    public BookingHomestay rejectBookingForHomestay(Long bookingId, Long homestayId, String message) {

        BookingHomestay bookingHomestay = bookingHomestayRepo.findBookingHomestayById(bookingId, homestayId).get();
        SwmUser user = bookingHomestay.getHomestay().getLandlord().getUser();
        bookingHomestay.setStatus(BookingStatus.REJECTED.name());
        bookingHomestay.setUpdatedBy(user.getUsername());
        bookingHomestay.setUpdatedDate(dateFormatUtil.formatDateTimeNowToString());

        mailService.informBookingForHomestayRejected(bookingHomestay, message);

        return bookingHomestay;
    }

    @Override
    public PagedListHolder<Booking> filterPassengerBooking(FilterBookingRequestDto filterBookingRequest,
            int page, int size, boolean isNextPage, boolean isPreviousPage) {
        List<Booking> bookingList = this.filterPassengerBookingByHost(filterBookingRequest.getIsHost());
        if (filterBookingRequest != null) {
            if (filterBookingRequest.getHomestayType() != null) {
                bookingList = this.filterPassengerBookingByHomestayType(bookingList,
                        filterBookingRequest.getHomestayType());
            }

            if (filterBookingRequest.getStatus() != null) {
                bookingList = this.filterPassengerBookingByStatus(bookingList, filterBookingRequest.getStatus());
            }
        }

        PagedListHolder<Booking> pagedListHolder = new PagedListHolder<>(bookingList);
        pagedListHolder.setPage(page);
        pagedListHolder.setPageSize(size);
        if (!pagedListHolder.isLastPage() && isNextPage == true && isPreviousPage == false) {
            pagedListHolder.nextPage();
        } else if (!pagedListHolder.isFirstPage() && isPreviousPage == true && isNextPage == false) {
            pagedListHolder.previousPage();
        }

        return pagedListHolder;
    }

    @Override
    public List<Booking> filterPassengerBookingByHomestayType(List<Booking> bookingList, String homestayType) {
        bookingList = bookingList.stream().filter(b -> b.getHomestayType().equalsIgnoreCase(homestayType))
                .collect(Collectors.toList());
        return bookingList;
    }

    @Override
    public List<Booking> filterPassengerBookingByStatus(List<Booking> bookingList, String status) {
        bookingList = bookingList.stream().filter(b -> b.getStatus().equalsIgnoreCase(status))
                .collect(Collectors.toList());
        return bookingList;
    }

    @Override
    public List<Booking> filterPassengerBookingByHost(boolean isHost) {
        SwmUser user = userService.authenticatedUser();
        List<Booking> bookingList;
        List<Booking> shareCodeBooking = new ArrayList<>();
        if (isHost) {
            bookingList = user.getPassengerProperty().getBookings();
        } else {
            for (BookingInviteCode s : user.getPassengerProperty().getInviteCodes()) {
                shareCodeBooking.add(s.getBooking());
            }
            bookingList = shareCodeBooking;
        }
        return bookingList;
    }

    @Override
    @Transactional
    public BookingHomestay checkInForHomestay(Long bookingId, Long homestayId) {
        BookingHomestay bookingHomestay = bookingHomestayRepo.findBookingHomestayById(bookingId, homestayId).get();
        if (dateFormatUtil.formatGivenDate(bookingHomestay.getBooking().getBookingFrom())
                .compareTo(dateFormatUtil.formatDateTimeNow()) == 0) {
            bookingHomestay.setStatus(BookingStatus.CHECKEDIN.name());
        } else {
            throw new InvalidException("Invalid check-in date");
        }

        return bookingHomestay;
    }

    @Override
    @Transactional
    public Booking checkInForBloc(Long bookingId) {
        Booking booking = this.findBookingById(bookingId);

        if (dateFormatUtil.formatGivenDate(booking.getBookingFrom())
                .compareTo(dateFormatUtil.formatDateTimeNow()) == 0) {
            booking.setStatus(BookingStatus.CHECKEDIN.name());

            booking.getBookingHomestays().forEach(b -> b.setStatus(BookingStatus.CHECKEDIN.name()));
        } else {
            throw new InvalidException("Invalid check-in date");
        }

        return booking;
    }

    @Override
    @Transactional
    public BookingHomestay checkOutForHomestay(Long bookingId, Long homestayId) {

        BookingHomestay bookingHomestay = bookingHomestayRepo.findBookingHomestayById(bookingId, homestayId).get();
        Landlord landlord = bookingHomestay.getHomestay().getLandlord();
        Booking booking = bookingHomestay.getBooking();
        SwmUser user = booking.getPassenger().getUser();
        boolean isBookingFinished = true;
        if (dateFormatUtil.formatGivenDate(booking.getBookingFrom()).compareTo(dateFormatUtil.formatDateTimeNow()) == 0
                || dateFormatUtil
                        .formatGivenDate(booking.getBookingFrom()).compareTo(dateFormatUtil.formatDateTimeNow()) == 1) {
            if (dateFormatUtil.formatGivenDate(booking.getBookingTo())
                    .compareTo(dateFormatUtil.formatDateTimeNow()) == 0) {
                bookingHomestay.setStatus(BookingStatus.CHECKEDOUT.name());

            } else if (dateFormatUtil.formatGivenDate(booking.getBookingTo())
                    .compareTo(dateFormatUtil.formatDateTimeNow()) == 1) {
                int remainDays = dateFormatUtil.differenceInDays(dateFormatUtil.formatDateTimeNowToString(),
                        booking.getBookingTo()) - 1;
                Long totalRemainHomestayPrice = bookingHomestay.getHomestay().getPrice() * remainDays;
                Long totalRemainServicePrice = 0L;

                if (booking.getBookingHomestayServices() != null) {
                    for (BookingHomestayService bs : booking.getBookingHomestayServices()) {
                        for (BookingHomestay bh : booking.getBookingHomestays()) {
                            if (bs.getHomestayName().equals(bh.getHomestay().getName())) {
                                totalRemainServicePrice = totalRemainServicePrice + bs.getHomestayService().getPrice();
                            }
                        }
                    }
                }

                // totalRemainServicePrice = totalRemainServicePrice * remainDays;
                Long totalRemainBookingPrice = booking.getTotalBookingPrice() - (totalRemainHomestayPrice
                        + totalRemainServicePrice);
                Long totalRemainBookingHomestayPrice = bookingHomestay.getTotalBookingPrice()
                        - totalRemainHomestayPrice;
                bookingHomestay.setTotalBookingPrice(totalRemainBookingHomestayPrice);
                booking.setTotalBookingPrice(totalRemainBookingPrice);
                if (bookingHomestay.getPaymentMethod().equalsIgnoreCase(PaymentMethod.SWM_WALLET.name())) {
                    for (BookingDeposit d : booking.getBookingDeposits()) {
                        if (d.getDepositForHomestay().equals(bookingHomestay.getHomestay().getName())) {
                            Long totalRemainUnpaidAmount = totalRemainBookingHomestayPrice - d.getPaidAmount();
                            d.setUnpaidAmount(totalRemainUnpaidAmount);
                        }
                    }
                }

                bookingHomestay.setStatus(BookingStatus.CHECKEDOUT.name());
            } else {
                throw new InvalidException("Invalid check-out date");
            }
        } else {
            throw new InvalidException("Invalid check-out date");
        }

        if (bookingHomestay.getPaymentMethod().equalsIgnoreCase(PaymentMethod.SWM_WALLET.name())) {
            BookingDeposit bookingDeposit = bookingHomestay.getBooking().getBookingDeposits().stream()
                    .filter(d -> d.getDepositForHomestay().equals(bookingHomestay.getHomestay().getName()))
                    .findAny()
                    .get();
            List<LandlordCommission> currentLandlordCommissions = landlord.getBalanceWallet().getLandlordWallet()
                    .getLandlordCommissions();
            LandlordCommission landlordCommission = new LandlordCommission();
            Long commissionAmount = this.getLandlordCommission(bookingHomestay.getTotalBookingPrice());
            landlordCommission.setCommission(commissionAmount);
            landlordCommission.setCommissionType(CommissionType.PAID_COMMISSION.name());
            landlordCommission.setCreatedBy(landlord.getUser().getUsername());
            landlordCommission.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
            landlordCommission.setLandlordWallet(landlord.getBalanceWallet().getLandlordWallet());
            currentLandlordCommissions.add(landlordCommission);
            landlord.getBalanceWallet().getLandlordWallet().setLandlordCommissions(currentLandlordCommissions);
            landlordCommissionRepo.save(landlordCommission);
            bookingDeposit.setStatus(DepositStatus.PAID.name());
            Long currentUserBalance = user.getPassengerProperty().getBalanceWallet().getTotalBalance();
            currentUserBalance = currentUserBalance - bookingDeposit.getUnpaidAmount();
            user.getPassengerProperty().getBalanceWallet().setTotalBalance(currentUserBalance);
            Long currentOwnerBalance = landlord.getBalanceWallet().getTotalBalance();
            currentOwnerBalance = (currentOwnerBalance + bookingDeposit.getUnpaidAmount()) - commissionAmount;
            landlord.getBalanceWallet().setTotalBalance(currentOwnerBalance);

        }
        for (BookingHomestay bh : bookingHomestay.getBooking().getBookingHomestays()) {
            if (bh.getStatus().equalsIgnoreCase(BookingStatus.PENDING.name()) || bh.getStatus()
                    .equalsIgnoreCase(BookingStatus.CHECKEDIN.name())) {
                isBookingFinished = false;
            }
        }
        if (isBookingFinished) {
            bookingHomestay.getBooking().setStatus(BookingStatus.FINISHED.name());
        }
        if (bookingHomestay.getHomestay().getCampaigns() != null) {
            for (PromotionCampaign p : bookingHomestay.getHomestay().getCampaigns()) {
                if (p.getStatus().equalsIgnoreCase(PromotionCampaignStatus.PROGRESSING.name())) {
                    Long currentProfit = p.getTotalProfit();
                    Long currentBooking = p.getTotalBooking();
                    currentProfit = currentProfit + bookingHomestay.getTotalBookingPrice();
                    currentBooking = currentBooking + 1;
                    p.setTotalProfit(currentProfit);
                    p.setTotalBooking(currentBooking);
                }
            }
        }
        LocalDate localDateNow = LocalDate.parse(dateFormatUtil.formatDateTimeNowToString(),
                DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        LocalDate calculateExpiredDate = LocalDate.from(localDateNow)
                .plusDays(30);

        List<Promotion> promotionList = new ArrayList<>();
        Date expiredDate = dateFormatUtil.formatGivenDate(calculateExpiredDate.toString());

        List<BookingHomestay> hostCheckedOutBookingHomestayList = new ArrayList<>();
        List<Booking> userBookingList = user.getPassengerProperty().getBookings().stream()
                .filter(b -> b.getHomestayType().equalsIgnoreCase(HomestayType.HOMESTAY.name()))
                .collect(Collectors.toList());
        for (Booking b : userBookingList) {
            for (BookingHomestay bh : b.getBookingHomestays()) {
                if (bh.getStatus().equalsIgnoreCase(BookingStatus.CHECKEDOUT.name())) {
                    hostCheckedOutBookingHomestayList.add(bh);
                }
            }
        }
        if (user.getPassengerProperty().getInviteCodes() != null) {
            for (BookingInviteCode i : user.getPassengerProperty().getInviteCodes()) {
                for (BookingHomestay bh : i.getBooking().getBookingHomestays()) {
                    if (bh.getStatus().equalsIgnoreCase(BookingStatus.CHECKEDOUT.name())
                            && bh.getBooking().getHomestayType().equalsIgnoreCase(HomestayType.HOMESTAY.name())) {
                        hostCheckedOutBookingHomestayList.add(bh);
                    }
                }
            }
        }
        if (hostCheckedOutBookingHomestayList.size() % 3 == 0) {
            Promotion promotion = new Promotion();
            Random random = new Random();
            int randomNumber = random.nextInt(9000) + 999;
            StringBuilder promotionCodeBuilder = new StringBuilder();
            promotionCodeBuilder.append("HOST").append(randomNumber);
            promotion.setCode(promotionCodeBuilder.toString());
            promotion.setDiscountAmount(HOMESTAY_DISCOUNT_AMOUNT);
            promotion.setEndDate(dateFormatUtil.formatGivenDateTimeToString(expiredDate));
            promotion.setCreatedBy(user.getUsername());
            promotion.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
            promotion.setPassenger(user.getPassengerProperty());
            promotion.setHomestayType(HomestayType.HOMESTAY.name());
            user.getPassengerProperty().setPromotions(List.of(promotion));
            promotionList.add(promotion);

        }
        if (booking.getInviteCode().getPassengers() != null) {
            List<Passenger> guestList = booking.getInviteCode().getPassengers();
            for (Passenger p : guestList) {

                List<BookingHomestay> guestCheckedoutBookingHomestayList = new ArrayList<>();
                for (Booking b : p.getBookings()) {
                    if (b.getHomestayType().equalsIgnoreCase(HomestayType.HOMESTAY.name())) {
                        for (BookingHomestay bh : b.getBookingHomestays()) {
                            if (bh.getStatus().equalsIgnoreCase(BookingStatus.CHECKEDOUT.name())) {
                                guestCheckedoutBookingHomestayList.add(bh);
                            }
                        }
                    }
                }
                for (BookingInviteCode i : p.getInviteCodes()) {
                    if (i.getBooking().getHomestayType().equalsIgnoreCase(HomestayType.HOMESTAY.name())) {
                        for (BookingHomestay bh : i.getBooking().getBookingHomestays()) {
                            if (bh.getStatus().equalsIgnoreCase(BookingStatus.CHECKEDOUT.name())) {
                                guestCheckedoutBookingHomestayList.add(bh);
                            }
                        }
                    }
                }
                if (guestCheckedoutBookingHomestayList.size() % 3 == 0) {
                    Promotion guestPromotion = new Promotion();
                    Random random = new Random();
                    int randomNumber = random.nextInt(9000) + 999;
                    StringBuilder promotionCodeBuilder = new StringBuilder();
                    promotionCodeBuilder.append("GUEST").append(randomNumber);
                    guestPromotion.setCode(promotionCodeBuilder.toString());
                    guestPromotion.setHomestayType(HomestayType.HOMESTAY.name());
                    guestPromotion.setDiscountAmount(HOMESTAY_DISCOUNT_AMOUNT);
                    guestPromotion.setEndDate(dateFormatUtil.formatGivenDateTimeToString(expiredDate));
                    guestPromotion.setCreatedBy(user.getUsername());
                    guestPromotion.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
                    guestPromotion.setPassenger(p);
                    p.setPromotions(List.of(guestPromotion));
                    promotionList.add(guestPromotion);
                }
            }
        }
        if (promotionList.size() > 0) {
            promotionRepo.saveAll(promotionList);
        }

        return bookingHomestay;
    }

    @Override
    @Transactional
    public Booking checkOutForBloc(Long bookingId) {

        Booking booking = this.findBookingById(bookingId);
        SwmUser user = booking.getPassenger().getUser();
        Landlord landlord = booking.getBloc().getLandlord();
        if (dateFormatUtil.formatGivenDate(booking.getBookingFrom()).compareTo(dateFormatUtil.formatDateTimeNow()) == 0
                || dateFormatUtil
                        .formatGivenDate(booking.getBookingTo()).compareTo(dateFormatUtil.formatDateTimeNow()) == 1) {
            if (dateFormatUtil.formatGivenDate(booking.getBookingTo())
                    .compareTo(dateFormatUtil.formatDateTimeNow()) == 0) {
                booking.setStatus(BookingStatus.CHECKEDOUT.name());
                booking.getBookingHomestays().forEach(b -> b.setStatus(BookingStatus.CHECKEDOUT.name()));
            } else if (dateFormatUtil.formatGivenDate(booking.getBookingTo())
                    .compareTo(dateFormatUtil.formatDateTimeNow()) == 1) {
                int remainDays = dateFormatUtil.differenceInDays(dateFormatUtil.formatDateTimeNowToString(),
                        booking.getBookingTo()) - 1;
                Long totalRemainHomestayPrice = 0L;
                Long totalRemainServicePrice = 0L;

                for (BookingHomestay b : booking.getBookingHomestays()) {
                    totalRemainHomestayPrice = totalRemainHomestayPrice + b.getHomestay().getPrice();
                }

                if (booking.getBookingHomestayServices() != null) {
                    for (BookingHomestayService bs : booking.getBookingHomestayServices()) {
                        for (BookingHomestay bh : booking.getBookingHomestays()) {
                            if (bs.getHomestayName().equals(bh.getHomestay().getName())) {
                                totalRemainServicePrice = totalRemainServicePrice + bs.getHomestayService().getPrice();
                            }
                        }
                    }
                }

                // totalRemainServicePrice = totalRemainServicePrice * remainDays;
                totalRemainHomestayPrice = totalRemainHomestayPrice * remainDays;
                Long totalRemainBookingPrice = (booking.getTotalBookingPrice() - (totalRemainHomestayPrice
                        + totalRemainServicePrice));
                booking.setTotalBookingPrice(totalRemainBookingPrice);
                if (booking.getBookingHomestays().stream().map(bh -> bh.getPaymentMethod()).findFirst().get()
                        .equalsIgnoreCase(PaymentMethod.SWM_WALLET.name())) {
                    for (BookingDeposit d : booking.getBookingDeposits()) {
                        if (d.getDepositForHomestay().equals(booking.getBloc().getName())) {
                            Long totalRemainUnpaidAmount = totalRemainBookingPrice - d.getPaidAmount();
                            d.setUnpaidAmount(totalRemainUnpaidAmount);
                        }
                    }
                }

                booking.setStatus(BookingStatus.CHECKEDOUT.name());
                booking.getBookingHomestays().forEach(b -> b.setStatus(BookingStatus.CHECKEDOUT.name()));
            } else {
                throw new InvalidException("Invalid check-out date");
            }
        } else {
            throw new InvalidException("Invalid check-out date");
        }

        if (booking.getBloc().getCampaigns() != null) {
            for (PromotionCampaign p : booking.getBloc().getCampaigns()) {
                if (p.getStatus().equalsIgnoreCase(PromotionCampaignStatus.PROGRESSING.name())) {
                    Long currentProfit = p.getTotalProfit();
                    Long currentBooking = p.getTotalBooking();
                    currentProfit = currentProfit + booking.getTotalBookingPrice();
                    currentBooking = currentBooking + 1;
                    p.setTotalProfit(currentProfit);
                    p.setTotalBooking(currentBooking);
                }
            }
        }
        if (booking.getBookingHomestays().stream().map(bh -> bh.getPaymentMethod()).findFirst().get()
                .equalsIgnoreCase(PaymentMethod.SWM_WALLET.name())) {
            BookingDeposit bookingDeposit = booking.getBookingDeposits().stream()
                    .filter(d -> d.getDepositForHomestay().equals(booking.getBloc().getName())).findAny().get();

            Long commissionAmount = this.getLandlordCommission(booking.getTotalBookingPrice());
            List<LandlordCommission> currentLandlordCommissions = landlord.getBalanceWallet().getLandlordWallet()
                    .getLandlordCommissions();
            LandlordCommission landlordCommission = new LandlordCommission();
            landlordCommission.setCommission(commissionAmount);
            landlordCommission.setCommissionType(CommissionType.PAID_COMMISSION.name());
            landlordCommission.setCreatedBy(landlord.getUser().getUsername());
            landlordCommission.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
            landlordCommission.setLandlordWallet(landlord.getBalanceWallet().getLandlordWallet());
            currentLandlordCommissions.add(landlordCommission);
            landlord.getBalanceWallet().getLandlordWallet().setLandlordCommissions(currentLandlordCommissions);
            landlordCommissionRepo.save(landlordCommission);
            Long currentUserBalance = user.getPassengerProperty().getBalanceWallet().getTotalBalance();
            currentUserBalance = currentUserBalance - bookingDeposit.getUnpaidAmount();
            user.getPassengerProperty().getBalanceWallet().setTotalBalance(currentUserBalance);
            Long currentOwnerBalance = landlord.getBalanceWallet().getTotalBalance();
            currentOwnerBalance = (currentOwnerBalance + bookingDeposit.getUnpaidAmount()) - commissionAmount;
            landlord.getBalanceWallet().setTotalBalance(currentOwnerBalance);
            bookingDeposit.setStatus(DepositStatus.PAID.name());
        }
        LocalDate localDateNow = LocalDate.parse(dateFormatUtil.formatDateTimeNowToString(),
                DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        LocalDate calculateExpiredDate = LocalDate.from(localDateNow)
                .plusDays(30);

        List<Promotion> promotionList = new ArrayList<>();
        Date expiredDate = dateFormatUtil.formatGivenDate(calculateExpiredDate.toString());
        List<Passenger> guestList = booking.getInviteCode().getPassengers();

        List<Booking> hostCheckedOutBookingList = new ArrayList<>();
        for (Booking b : user.getPassengerProperty().getBookings()) {
            if (b.getHomestayType().equalsIgnoreCase(HomestayType.BLOC.name())
                    && b.getStatus().equalsIgnoreCase(BookingStatus.CHECKEDOUT.name())) {
                hostCheckedOutBookingList.add(b);
            }
        }
        if (user.getPassengerProperty().getInviteCodes() != null) {
            for (BookingInviteCode i : user.getPassengerProperty().getInviteCodes()) {
                if (i.getBooking().getStatus().equalsIgnoreCase(BookingStatus.CHECKEDOUT.name())
                        && i.getBooking().getHomestayType().equalsIgnoreCase(HomestayType.BLOC.name())) {
                    hostCheckedOutBookingList.add(i.getBooking());
                }
            }
        }

        if (hostCheckedOutBookingList.size() % 3 == 0) {
            Promotion promotion = new Promotion();
            Random random = new Random();
            int randomNumber = random.nextInt(9000) + 999;
            StringBuilder promotionCodeBuilder = new StringBuilder();
            promotionCodeBuilder.append("HOST").append(randomNumber);
            promotion.setCode(promotionCodeBuilder.toString());
            promotion.setDiscountAmount(BLOC_DISCOUNT_AMOUNT);
            promotion.setEndDate(dateFormatUtil.formatGivenDateTimeToString(expiredDate));
            promotion.setCreatedBy(user.getUsername());
            promotion.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
            promotion.setPassenger(user.getPassengerProperty());
            promotion.setHomestayType(HomestayType.BLOC.name());
            user.getPassengerProperty().setPromotions(List.of(promotion));
            promotionList.add(promotion);

        }
        if (guestList != null) {
            for (Passenger p : guestList) {

                List<Booking> guestCheckedoutBookingList = new ArrayList<>();
                for (Booking b : p.getBookings()) {
                    if (b.getStatus().equalsIgnoreCase(BookingStatus.CHECKEDOUT.name())
                            && b.getHomestayType().equalsIgnoreCase(HomestayType.BLOC.name())) {
                        guestCheckedoutBookingList.add(b);
                    }
                }
                for (BookingInviteCode i : p.getInviteCodes()) {
                    if (i.getBooking().getStatus().equalsIgnoreCase(BookingStatus.CHECKEDOUT.name())) {
                        guestCheckedoutBookingList.add(i.getBooking());
                    }
                }
                if (guestCheckedoutBookingList.size() % 3 == 0) {
                    Promotion guestPromotion = new Promotion();
                    Random random = new Random();
                    int randomNumber = random.nextInt(9000) + 999;
                    StringBuilder promotionCodeBuilder = new StringBuilder();
                    promotionCodeBuilder.append("GUEST").append(randomNumber);
                    guestPromotion.setCode(promotionCodeBuilder.toString());
                    guestPromotion.setHomestayType(HomestayType.BLOC.name());
                    guestPromotion.setDiscountAmount(HOMESTAY_DISCOUNT_AMOUNT);
                    guestPromotion.setEndDate(dateFormatUtil.formatGivenDateTimeToString(expiredDate));
                    guestPromotion.setCreatedBy(user.getUsername());
                    guestPromotion.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
                    guestPromotion.setPassenger(p);
                    p.setPromotions(List.of(guestPromotion));
                    promotionList.add(guestPromotion);
                }
            }
        }
        if (promotionList.size() > 0) {
            promotionRepo.saveAll(promotionList);
        }

        return booking;
    }

    @Override
    @Transactional
    public Booking acceptBookingForBloc(Long bookingId) {
        SwmUser landlordUser = userService.authenticatedUser();
        Booking booking = this.findBookingById(bookingId);
        SwmUser passengerUser = booking.getPassenger().getUser();
        booking.setStatus(BookingStatus.ACCEPTED.name());
        booking.getBookingHomestays().forEach(b -> b.setStatus(BookingStatus.ACCEPTED.name()));
        Long currentPassengerWalletBalance = passengerUser.getPassengerProperty().getBalanceWallet().getTotalBalance();
        switch (PaymentMethod.valueOf(booking.getBookingHomestays().stream().map(b -> b.getPaymentMethod()).findFirst()
                .get().toUpperCase())) {
            case SWM_WALLET:
                SwmUser owner = null;
                Long currentOwnerBalanceWallet = null;

                Long currentBookingTotalPrice = booking.getTotalBookingPrice();

                Long paidDeposit = this.getBookingDeposit(currentBookingTotalPrice);
                Long unpaidDeposit = currentBookingTotalPrice - paidDeposit;
                booking.setTotalBookingDeposit(paidDeposit);
                currentPassengerWalletBalance = currentPassengerWalletBalance
                        - paidDeposit;
                passengerUser.getPassengerProperty().getBalanceWallet()
                        .setTotalBalance(currentPassengerWalletBalance);

                owner = booking.getBloc().getLandlord().getUser();
                currentOwnerBalanceWallet = owner.getLandlordProperty().getBalanceWallet()
                        .getTotalBalance();
                currentOwnerBalanceWallet = currentOwnerBalanceWallet
                        + paidDeposit;
                owner.getLandlordProperty().getBalanceWallet()
                        .setTotalBalance(currentOwnerBalanceWallet);
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
                bookingDeposit.getDeposit().setStatus(DepositStatus.UNPAID.name());

                break;
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
                List<LandlordCommission> currentLandlordCommissions = landlordUser.getLandlordProperty()
                        .getBalanceWallet().getLandlordWallet().getLandlordCommissions();
                LandlordCommission landlordCommission = new LandlordCommission();
                landlordCommission.setCommission(landlordTotalCommission);
                landlordCommission.setCommissionType(CommissionType.PAID_COMMISSION.name());
                landlordCommission.setLandlordWallet(
                        landlordUser.getLandlordProperty().getBalanceWallet().getLandlordWallet());
                currentLandlordCommissions.add(landlordCommission);
                landlordUser.getLandlordProperty().getBalanceWallet().getLandlordWallet()
                        .setLandlordCommissions(currentLandlordCommissions);
                landlordCommission.setCreatedBy(landlordUser.getUsername());
                landlordCommission.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
                landlordCommissionRepo.save(landlordCommission);
                if (landlordUser.getLandlordProperty().getBalanceWallet()
                        .getTotalBalance() <= 50000) {
                    mailService.lowBalanceInformToLandlord(landlordUser.getUsername());
                }
                break;
        }
        return booking;
    }

    @Override
    @Transactional
    public Booking rejectBookingForBloc(Long bookingId, String message) {

        Booking booking = this.findBookingById(bookingId);
        SwmUser user = booking.getBloc().getLandlord().getUser();
        booking.setStatus(BookingStatus.REJECTED.name());
        for (BookingHomestay b : booking.getBookingHomestays()) {
            b.setStatus(BookingStatus.REJECTED.name());
        }
        booking.setUpdatedBy(user.getUsername());
        booking.setUpdatedDate(dateFormatUtil.formatDateTimeNowToString());
        mailService.informBookingForBlocRejected(booking, message);
        return booking;
    }

    @Override
    @Transactional
    public BookingHomestay updateBookingHomestayPaymentMethod(Long bookingId, Long homestayId, String paymentMethod) {
        BookingHomestay bookingHomestay = bookingHomestayRepo.findBookingHomestayById(bookingId, homestayId).get();
        bookingHomestay.setPaymentMethod(paymentMethod);
        return bookingHomestay;
    }

    @Override
    public Boolean isHomestayHaveBookingPending(String homestayName) {
        List<BookingHomestay> checkPendingBookingHomestayOfHomestay = bookingHomestayRepo
                .checkPendingBookingHomestay(homestayName, BookingStatus.PENDING.name());
        return checkPendingBookingHomestayOfHomestay.size() > 0;
    }

    @Override
    public Boolean isBlocHomestayHaveBookingPending(String blocName) {
        List<Booking> checkPendingBookingBlocHomestay = bookingRepo.checkBookingPendingBloc(blocName,
                BookingStatus.PENDING.name());
        return checkPendingBookingBlocHomestay.size() > 0;
    }

    @Override
    public List<Booking> getLandlordBookingBlocList(String blocName, String status) {
        List<Booking> bookings = bookingRepo.findBookingBlocListByBlocNameAndStatus(blocName, status);
        return bookings;
    }

    @Override
    @Transactional
    public BookingHomestay cancelBookingHomestay(Long bookingId, Long homestayId, boolean isMissedCheckinDate) {
        BookingHomestay bookingHomestay = bookingHomestayRepo.findBookingHomestayById(bookingId, homestayId).get();
        bookingHomestay.setStatus(BookingStatus.CANCELED.name());
        boolean isBookingFinished = false;

        for (BookingHomestay bh : bookingHomestay.getBooking().getBookingHomestays()) {
            if (bh.getStatus().equalsIgnoreCase(BookingStatus.CHECKEDOUT.name())
                    || bh.getStatus().equalsIgnoreCase(BookingStatus.CANCELED.name())
                    || bh.getStatus().equalsIgnoreCase(BookingStatus.REJECTED.name())) {
                isBookingFinished = true;
            }
        }
        if (isBookingFinished) {
            bookingHomestay.getBooking().setStatus(BookingStatus.FINISHED.name());
        }

        return bookingHomestay;
    }

    @Override
    @Transactional
    public Booking cancelBookingBloc(Long bookingId, boolean isMissedCheckinDate) {
        Booking booking = this.findBookingById(bookingId);
        booking.setStatus(BookingStatus.CANCELED.name());

        return booking;
    }

    @Override
    @Transactional
    public void bookingDateHandler() {
        List<Booking> bookings = bookingRepo.findAll();
        for (Booking b : bookings) {
            if (dateFormatUtil.formatGivenDate(b.getBookingFrom())
                    .compareTo(dateFormatUtil.formatDateTimeNow()) == -1) {

                if (b.getHomestayType().equalsIgnoreCase(HomestayType.HOMESTAY.name())) {
                    b.setStatus(BookingStatus.FINISHED.name());
                    for (BookingHomestay bh : b.getBookingHomestays()) {
                        if (bh.getStatus().equalsIgnoreCase(BookingStatus.ACCEPTED.name())) {
                            this.cancelBookingHomestay(bh.getBooking().getId(), bh.getHomestay().getId(), true);
                        } else if (bh.getStatus().equalsIgnoreCase(BookingStatus.PENDING.name())) {
                            this.rejectBookingForHomestay(bh.getBooking().getId(), bh.getHomestay().getId(),
                                    "Homestay won't receive any guest right now");
                        }
                    }
                } else {
                    if (b.getStatus().equalsIgnoreCase(BookingStatus.ACCEPTED.name())) {
                        this.cancelBookingBloc(b.getId(), true);
                    } else if (b.getStatus().equalsIgnoreCase(BookingStatus.PENDING.name())) {
                        this.rejectBookingForBloc(b.getId(), "Block homestay won't receive any guest right now");
                    }
                }
            }

        }
    }

    @Override
    public Booking getBookingByCode(String code) {
        SwmUser user = userService.authenticatedUser();
        Booking booking = bookingRepo.findBookingByCode(code)
                .orElseThrow(() -> new NotFoundException("Booking not found"));
        if (booking.getHomestayType().equalsIgnoreCase(HomestayType.HOMESTAY.name())) {
            List<BookingHomestay> userHomestay = new ArrayList<>();
            for (BookingHomestay bh : booking.getBookingHomestays()) {
                if (user.getLandlordProperty().getHomestays().contains(bh.getHomestay())) {
                    userHomestay.add(bh);
                }
            }
            if (userHomestay.size() > 0) {
                List<BookingHomestayService> bookingHomestayServices = new ArrayList<>();
                for (BookingHomestayService bs : booking.getBookingHomestayServices()) {
                    for (BookingHomestay bh : userHomestay) {
                        if (bs.getHomestayService().getHomestay().getName() == bh.getHomestay().getName()) {
                            bookingHomestayServices.add(bs);
                        }
                    }
                }
                booking.setBookingHomestayServices(bookingHomestayServices);
                booking.setBookingHomestays(userHomestay);

            } else {
                throw new NotFoundException("Booking not found");
            }
        }
        return booking;
    }

    @Override
    public BookingHomestay getBookingHomestayByHomestayIdAndBookingId(Long bookingId, Long homestayId) {
        BookingHomestay bookingHomestay = bookingHomestayRepo.findBookingHomestayById(bookingId, homestayId)
                .orElseThrow(() -> new NotFoundException("Can't find booking homestay"));

        return bookingHomestay;
    }

}
