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
import com.sbhs.swm.util.DateFormatUtil;

@Service
public class BookingService implements IBookingService {

    private enum validateBookingDate {
        OK,
        INVALID,
        START_ALREADY_BOOKED,
        END_ALREADY_BOOKED,
        ON_BOOKING_PERIOD
    }

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
        String validateBookingDateString = checkBookingDate(booking.getBookingFrom(), booking.getBookingTo(),
                homestayName);
        switch (validateBookingDate.valueOf(validateBookingDateString)) {
            case ON_BOOKING_PERIOD:
                throw new InvalidBookingException(validateBookingDateString);
            case START_ALREADY_BOOKED:
                throw new InvalidBookingException(validateBookingDateString);
            case END_ALREADY_BOOKED:
                throw new InvalidBookingException(validateBookingDateString);
            case INVALID:
                throw new InvalidBookingException(validateBookingDateString);
            case OK:
                Homestay homestay = homestayService.findHomestayByName(homestayName);
                int totalHomestayRoomBooked = bookingRepo.totalHomestayRoomBooked(homestayName);
                int availableRoom = homestay.getAvailableRooms() - totalHomestayRoomBooked;
                if (availableRoom == 0 || booking.getTotalRoom() > availableRoom) {
                    throw new BookingOutOfRoomException();
                }
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
                homestay.setAvailableRooms(availableRoom);
                user.getPassengerProperty().setBookings(List.of(booking));
                Booking savedBooking = bookingRepo.save(booking);

                mailService.informBookingToLandlord(savedBooking);
                return savedBooking;
            default:
                return null;
        }

    }

    @Override
    public String checkBookingDate(String startDate, String endDate, String homestayName) {
        List<Booking> bookings = bookingRepo.findAllHomestayBooking(homestayName);
        Date currentStart = dateFormatUtil.formatGivenDate(startDate);
        Date currentEnd = dateFormatUtil.formatGivenDate(endDate);
        if (currentStart.after(currentEnd) || currentStart.compareTo(currentEnd) == 0) {
            return validateBookingDate.INVALID.name();
        }
        for (Booking b : bookings) {
            Date bookedStart = dateFormatUtil.formatGivenDate(b.getBookingFrom());
            Date bookedEnd = dateFormatUtil.formatGivenDate(b.getBookingTo());
            if ((bookedStart.after(currentStart) && bookedStart.before(currentEnd))
                    && (bookedEnd.after(currentEnd) && bookedEnd.after(currentStart))) {
                return validateBookingDate.ON_BOOKING_PERIOD.name();
            } else if ((bookedStart.after(currentStart) && bookedStart.after(currentEnd))
                    && (bookedEnd.before(currentEnd) && bookedEnd.before(currentStart))) {
                return validateBookingDate.ON_BOOKING_PERIOD.name();
            } else if ((bookedStart.before(currentStart) && bookedStart.before(currentEnd))
                    && (bookedEnd.after(currentStart) && bookedEnd.before(currentEnd))) {
                return validateBookingDate.ON_BOOKING_PERIOD.name();
            } else if (bookedStart.compareTo(currentStart) == 0 || bookedStart.compareTo(currentEnd) == 0) {
                return validateBookingDate.START_ALREADY_BOOKED.name();
            } else if (bookedEnd.compareTo(currentEnd) == 0 || bookedEnd.compareTo(currentStart) == 0) {
                return validateBookingDate.END_ALREADY_BOOKED.name();
            }
        }
        return validateBookingDate.OK.name();
    }

}
