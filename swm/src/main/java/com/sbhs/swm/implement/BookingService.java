package com.sbhs.swm.implement;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Service;

import com.sbhs.swm.handlers.exceptions.BookingNotFoundException;
import com.sbhs.swm.handlers.exceptions.BookingOutOfRoomException;
import com.sbhs.swm.handlers.exceptions.InvalidBookingException;
import com.sbhs.swm.models.Booking;
import com.sbhs.swm.models.Homestay;
import com.sbhs.swm.models.HomestayService;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.models.status.BookingStatus;
import com.sbhs.swm.repositories.BookingRepo;
import com.sbhs.swm.repositories.HomestayServiceRepo;
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
    public List<Booking> findBookingsByUsername(String username) {
        List<Booking> bookings = bookingRepo.findBookingListByUsername(username);

        return bookings;
    }

    @Override
    public Booking findBookingById(Long id) {
        Booking booking = bookingRepo.findById(id).orElseThrow(() -> new BookingNotFoundException());

        return booking;
    }

    @Override
    public Booking createBooking(Booking booking, String homestayName, List<String> homestayServices) {
        SwmUser user = userService.authenticatedUser();
        Homestay homestay = homestayService.findHomestayByName(homestayName);
        List<HomestayService> homestayServiceList = homestayServices.stream()
                .map(s -> homestayServiceRepo.findHomestayServiceByName(s).orElseThrow())
                .collect(Collectors.toList());

        booking.setPassenger(user.getPassengerProperty());
        booking.setHomestay(homestay);
        booking.setHomestayServices(homestayServiceList);
        booking.getDeposit().setBooking(booking);
        booking.getDeposit()
                .setPassengerWallet(user.getPassengerProperty().getBalanceWallet().getPassengerWallet());
        user.getPassengerProperty().getBalanceWallet().getPassengerWallet()
                .setDeposits(List.of(booking.getDeposit()));
        booking.getHomestayServices().forEach(s -> s.setBookings(List.of(booking)));
        booking.setCreatedBy(user.getUsername());
        booking.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
        booking.setStatus(BookingStatus.PENDING.name());

        homestayServiceList.forEach(h -> h.setBookings(List.of(booking)));
        homestay.setBookings(List.of(booking));
        user.getPassengerProperty().setBookings(List.of(booking));
        Booking savedBooking = bookingRepo.save(booking);

        mailService.informBookingToLandlord(savedBooking);
        return savedBooking;
    }

    @Override
    public int checkBookingDate(String bookingStart, String bookingEnd, String homestayName,
            int totalBookingRoom) {
        String validateBookingDateString = bookingDateValidationUtil.bookingValidateString(bookingStart, bookingEnd,
                homestayName);
        Homestay homestay = homestayService.findHomestayByName(homestayName);
        int totalHomestayRoomBooked = bookingRepo.totalHomestayRoomBooked(homestayName) != null
                ? bookingRepo.totalHomestayRoomBooked(homestayName)
                : 0;
        int availableRoom = homestay.getAvailableRooms() - totalHomestayRoomBooked;

        switch (BookingDateValidationString.valueOf(validateBookingDateString)) {
            case INVALID:
                throw new InvalidBookingException(validateBookingDateString);
            case ON_BOOKING_PERIOD:
                if (availableRoom == 0 || totalBookingRoom > availableRoom) {
                    throw new BookingOutOfRoomException();
                }
                break;
            case CURRENT_START_ON_BOOKED_END:
                int totalRoomWillBeFree = 0;
                for (Booking b : homestay.getBookings()) {
                    Date bookedEnd = dateFormatUtil.formatGivenDate(b.getBookingTo());
                    Date currentStart = dateFormatUtil.formatGivenDate(bookingStart);
                    if (bookedEnd.before(currentStart) || bookedEnd.compareTo(currentStart) == 0) {
                        int totalFreeRoomOnDate = bookingRepo.totalHomestayRoomWillBeCheckedOut(homestayName,
                                b.getBookingTo()) != null ? bookingRepo.totalHomestayRoomWillBeCheckedOut(homestayName,
                                        b.getBookingTo()) : 0;
                        totalRoomWillBeFree = totalRoomWillBeFree + totalFreeRoomOnDate;
                    }
                }

                availableRoom = availableRoom + totalRoomWillBeFree;
                if (availableRoom == 0 || totalBookingRoom > availableRoom) {
                    throw new BookingOutOfRoomException();
                }
                return availableRoom;
            case CURRENT_END_ON_BOOKED_END:
                if (availableRoom == 0 || totalBookingRoom > availableRoom) {
                    throw new BookingOutOfRoomException();
                }
                return availableRoom;
            case CURRENT_START_ON_BOOKED_START:
                if (availableRoom == 0 || totalBookingRoom > availableRoom) {
                    throw new BookingOutOfRoomException();
                }
                return availableRoom;

            case OK:
                return availableRoom;
            default:
                return 0;
        }

        return 0;
    }

}
