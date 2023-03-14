package com.sbhs.swm.implement;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sbhs.swm.dto.request.TravelCartRequestDto;
import com.sbhs.swm.handlers.exceptions.BookingNotFoundException;
import com.sbhs.swm.handlers.exceptions.InvalidBookingException;
import com.sbhs.swm.models.BlocHomestay;
import com.sbhs.swm.models.Booking;
import com.sbhs.swm.models.Homestay;
import com.sbhs.swm.models.HomestayService;
import com.sbhs.swm.models.HomestayTravelCart;
import com.sbhs.swm.models.ServiceTravelCart;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.models.TravelCart;
import com.sbhs.swm.repositories.BookingDepositRepo;

import com.sbhs.swm.repositories.BookingRepo;
import com.sbhs.swm.repositories.HomestayServiceRepo;
import com.sbhs.swm.repositories.HomestayTravelCartRepo;
import com.sbhs.swm.repositories.LandlordCommissionRepo;
import com.sbhs.swm.repositories.ServiceTravelCartRepo;
import com.sbhs.swm.repositories.TravelCartRepo;
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
    private BookingRepo bookingRepo;

    @Autowired
    private HomestayServiceRepo homestayServiceRepo;

    @Autowired
    private LandlordCommissionRepo landlordCommissionRepo;

    @Autowired
    private ServiceTravelCartRepo serviceTravelCartRepo;

    @Autowired
    private BookingDepositRepo bookingDepositRepo;

    @Autowired
    private TravelCartRepo travelCartRepo;

    @Autowired
    private IUserService userService;

    @Autowired
    private IHomestayService homestayService;

    @Autowired
    private IMailService mailService;

    @Autowired
    private DateFormatUtil dateFormatUtil;

    @Autowired
    private HomestayTravelCartRepo homestayTravelCartRepo;

    @Autowired
    private BookingDateValidationUtil bookingDateValidationUtil;

    @Override
    public List<Booking> findBookingsByUsername(String username) {
        List<Booking> bookings = bookingRepo.findAll();

        return bookings;
    }

    @Override
    public Booking findBookingById(Long id) {
        Booking booking = bookingRepo.findById(id).orElseThrow(() -> new BookingNotFoundException());

        return booking;
    }

    // @Override
    // @Transactional
    // public Booking createBookingForHomestay(Booking booking, List<String>
    // homestayServices,
    // long depositAmount, List<String> homestayNames) {
    // SwmUser user = userService.authenticatedUser();
    // BookingHomestay bookingHomestay = new BookingHomestay();
    // List<BookingHomestay> bookingHomestayList = new ArrayList<>();
    // List<Homestay> homestayListByName = homestayNames.stream().map(h ->
    // homestayService.findHomestayByName(h))
    // .collect(Collectors.toList());
    // for (Homestay h : homestayListByName) {
    // if (h.getBloc() != null) {
    // booking.setHomestayType(HomestayType.BLOC.name());
    // } else {
    // booking.setHomestayType(HomestayType.HOMESTAY.name());
    // }
    // bookingHomestay.setHomestay(h);
    // bookingHomestayList.add(bookingHomestay);
    // }
    // if (homestayServices != null) {
    // List<HomestayService> homestayServiceList = homestayServices.stream()
    // .map(s -> homestayServiceRepo.findHomestayServiceByName(s).orElseThrow())
    // .collect(Collectors.toList());
    // booking.setHomestayServices(homestayServiceList);
    // homestayServiceList.forEach(h -> h.setBookings(List.of(booking)));
    // booking.getHomestayServices().forEach(s -> s.setBookings(List.of(booking)));
    // }
    // booking.setPassenger(user.getPassengerProperty());
    // booking.setHomestays(homestayListByName);

    // booking.setCreatedBy(user.getUsername());
    // booking.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
    // booking.setStatus(BookingStatus.PENDING.name());

    // user.getPassengerProperty().setBookings(List.of(booking));
    // Booking savedBooking = bookingRepo.save(booking);
    // switch (PaymentType.valueOf(booking.getPaymentType())) {
    // case SWM_WALLET:
    // long unpaidAmount = savedBooking.getTotalPrice() - depositAmount;
    // long currentPassengerWalletBalance =
    // user.getPassengerProperty().getBalanceWallet().getTotalBalance();
    // BookingDeposit bookingDeposit = new BookingDeposit();
    // bookingDeposit.setPaidAmount(depositAmount);
    // bookingDeposit.setUnpaidAmount(unpaidAmount);
    // bookingDeposit.setBooking(savedBooking);
    // bookingDeposit.setCreatedBy(user.getUsername());
    // bookingDeposit.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
    // bookingDeposit.setPassengerWallet(user.getPassengerProperty().getBalanceWallet().getPassengerWallet());

    // user.getPassengerProperty().getBalanceWallet().getPassengerWallet()
    // .setDeposits(List.of(bookingDeposit));
    // BookingDeposit savedBookingDeposit = bookingDepositRepo.save(bookingDeposit);
    // savedBooking.setDeposit(savedBookingDeposit);
    // user.getPassengerProperty().getBalanceWallet()
    // .setTotalBalance(currentPassengerWalletBalance -
    // savedBookingDeposit.getPaidAmount());

    // break;
    // case CASH:
    // Landlord ownerProperty = homestayListByName.stream().map(h ->
    // h.getLandlord()).findAny().get();

    // long commissiontAmount =
    // this.landlordCommissionAmount(savedBooking.getTotalPrice());
    // LandlordCommission landlordCommission = new LandlordCommission();
    // landlordCommission.setCommission(commissiontAmount);
    // landlordCommission.setCommissionType(CommissionType.UNPAID_COMMISSION.name());
    // landlordCommission.setLandlordWallet(ownerProperty.getBalanceWallet().getLandlordWallet());
    // landlordCommission.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());

    // LandlordCommission savedLandlordCommission =
    // landlordCommissionRepo.save(landlordCommission);
    // ownerProperty.getBalanceWallet().getLandlordWallet()
    // .setLandlordCommissions(List.of(savedLandlordCommission));

    // break;

    // }

    // mailService.informBookingToLandlord(savedBooking);
    // return savedBooking;
    // }

    private long landlordCommissionAmount(long totalBookingPrice) {
        long amount = (totalBookingPrice * 5) / 100;
        return amount;
    }

    @Override
    public Boolean canPassengerMakeBooking(long totalBookingPrice) {
        SwmUser user = userService.authenticatedUser();
        long currentTotalPassengerWalletBalance = user.getPassengerProperty().getBalanceWallet().getTotalBalance();
        long totalUnpaidDeposit = bookingDepositRepo.getTotalUnpaidAmountFromUser(user.getUsername()) != null
                ? bookingDepositRepo.getTotalUnpaidAmountFromUser(user.getUsername())
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
    public TravelCart addHomestayToPassengerTravelCart(TravelCartRequestDto travelCartRequest) {
        Long homestayServicePrice = 0L;
        SwmUser user = userService.authenticatedUser();
        TravelCart travelCart = new TravelCart();
        HomestayTravelCart homestayTravelCart = new HomestayTravelCart();
        Homestay homestay = homestayService.findHomestayByName(travelCartRequest.getHomestayName());
        List<HomestayService> homestayServices = travelCartRequest.getServiceNames().stream()
                .map(s -> homestayServiceRepo.findHomestayServiceByName(s).get()).collect(Collectors.toList());
        List<ServiceTravelCart> serviceTravelCarts = new ArrayList<>();
        for (HomestayService s : homestayServices) {
            homestayServicePrice = homestayServicePrice + s.getPrice();
            ServiceTravelCart serviceTravelCart = new ServiceTravelCart();
            serviceTravelCart.setHomestayService(s);
            serviceTravelCart.setPrice(s.getPrice());
            serviceTravelCart.setTravelCart(travelCart);
            ServiceTravelCart savedServiceTravelCart = serviceTravelCartRepo.save(serviceTravelCart);
            serviceTravelCarts.add(savedServiceTravelCart);
        }

        travelCart.setServiceTravelCarts(serviceTravelCarts);
        travelCart.setPassenger(user.getPassengerProperty());
        homestayTravelCart.setHomestay(homestay);
        homestayTravelCart.setTravelCart(travelCart);
        homestayTravelCart.setBookingFrom(travelCartRequest.getBookingFrom());
        homestayTravelCart.setBookingTo(travelCartRequest.getBookingTo());
        homestayTravelCart.setDeposit(this.getTravelCartDeposit(homestay.getPrice()));
        homestayTravelCart.setPrice(homestayServicePrice);
        HomestayTravelCart savedHomestayTravelCart = homestayTravelCartRepo.save(homestayTravelCart);
        homestay.setHomestayTravelCarts(List.of(savedHomestayTravelCart));

        travelCart.setHomestayTravelCarts(List.of(homestayTravelCart));
        TravelCart savedTravelCart = travelCartRepo.save(travelCart);
        user.getPassengerProperty().setTravelCart(List.of(travelCart));
        return savedTravelCart;
    }

    private Long getTravelCartDeposit(Long price) {
        return (price * 20) / 100;
    }

    private Long getTotalTravelDeposit(Long homestayPrice, Long homestayServicePrice) {
        Long total = homestayPrice + homestayServicePrice;
        return (total * 20) / 100;
    }

    // @Override
    // public Booking createBookingForHomestay(List<BookingRequestDto>
    // bookingRequestList) {
    // List<BookingHomestay> bookingHomestayList = new ArrayList<>();
    // List<BookingDeposit> bookingDepositList = new ArrayList<>();
    // SwmUser user = userService.authenticatedUser();
    // Booking booking = new Booking();
    // booking.setStatus(BookingStatus.PENDING.name());
    // booking.setPassenger(user.getPassengerProperty());
    // booking.setCreatedBy(user.getUsername());
    // booking.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
    // user.getPassengerProperty().setBookings(List.of(booking));
    // Long totalBookingPrice = 0L;
    // Long totalBookingDeposit = 0L;
    // for (BookingRequestDto b : bookingRequestList) {
    // totalBookingPrice = totalBookingPrice + b.getTotalPrice();
    // BookingHomestay bookingHomestay = new BookingHomestay();
    // BookingDeposit deposit = new BookingDeposit();
    // Homestay homestay = homestayService.findHomestayByName(b.getHomestayName());
    // if (homestay.getBloc() != null) {
    // booking.setHomestayType(HomestayType.BLOC.name());
    // } else {
    // booking.setHomestayType(HomestayType.HOMESTAY.name());
    // }
    // deposit.setPaidAmount(b.getDepositPaidAmount());
    // deposit.setUnpaidAmount(b.getTotalPrice() - b.getDepositPaidAmount());
    // deposit.setPassengerWallet(user.getPassengerProperty().getBalanceWallet().getPassengerWallet());
    // deposit.setCreatedBy(user.getUsername());
    // deposit.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
    // totalBookingDeposit = totalBookingDeposit + deposit.getUnpaidAmount();
    // bookingDepositList.add(deposit);
    // bookingHomestay.setBookingFrom(b.getBookingFrom());
    // bookingHomestay.setBookingTo(b.getBookingTo());
    // bookingHomestay.setDeposit(deposit);
    // bookingHomestay.setHomestay(homestay);
    // bookingHomestay.setBooking(booking);
    // bookingHomestay.setHomestayServices(b.getHomestayServicesName().stream()
    // .map(s ->
    // homestayServiceRepo.findHomestayServiceByName(s).get()).collect(Collectors.toList()));
    // bookingHomestay.setPrice(b.getTotalPrice());
    // bookingHomestay.setTotalReservation(b.getTotalReservation());
    // bookingHomestay.setPaymentType(b.getPaymentType());
    // bookingHomestayList.add(bookingHomestay);
    // }
    // user.getPassengerProperty().getBalanceWallet().getPassengerWallet().setDeposits(bookingDepositList);
    // booking.setTotalBookingDeposit(totalBookingDeposit);
    // booking.setTotalPrice(totalBookingPrice);
    // booking.setBookingHomestays(bookingHomestayList);
    // bookingHomestayList.forEach(b -> {
    // b.getHomestay().setBookingHomestays(bookingHomestayList);
    // b.getHomestayServices().forEach(s ->
    // s.setBookingHomestays(bookingHomestayList));
    // });
    // Booking savedBooking = bookingRepo.save(booking);

    // return savedBooking;
    // }

}
