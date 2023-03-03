package com.sbhs.swm.util;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;

import com.sbhs.swm.models.Booking;
import com.sbhs.swm.repositories.BookingRepo;

@Configuration
public class BookingDateValidationUtil {
    @Autowired
    private BookingRepo bookingRepo;

    @Autowired
    private DateFormatUtil dateFormatUtil;

    public String bookingValidateString(String startDate, String endDate, String homestayName) {
        List<Booking> bookings = bookingRepo.findAllHomestayBooking(homestayName);
        Date currentStart = dateFormatUtil.formatGivenDate(startDate);
        Date currentEnd = dateFormatUtil.formatGivenDate(endDate);
        if (currentStart.after(currentEnd) || currentStart.after(currentEnd)) {
            return BookingDateValidationString.INVALID.name();
        }
        for (Booking b : bookings) {
            Date bookedStart = dateFormatUtil.formatGivenDate(b.getBookingFrom());
            Date bookedEnd = dateFormatUtil.formatGivenDate(b.getBookingTo());
            if ((bookedStart.after(currentStart) && bookedStart.before(currentEnd))
                    && (bookedEnd.after(currentEnd) && bookedEnd.after(currentStart))) {
                return BookingDateValidationString.ON_BOOKING_PERIOD.name();
            } else if ((bookedStart.after(currentStart) && bookedStart.after(currentEnd))
                    && (bookedEnd.before(currentEnd) && bookedEnd.before(currentStart))) {
                return BookingDateValidationString.ON_BOOKING_PERIOD.name();
            } else if ((bookedStart.before(currentStart) && bookedStart.before(currentEnd))
                    && (bookedEnd.after(currentStart) && bookedEnd.before(currentEnd))) {
                return BookingDateValidationString.ON_BOOKING_PERIOD.name();
            } else if (bookedEnd.compareTo(currentStart) == 0 || bookedEnd.before(currentStart)) {
                return BookingDateValidationString.CURRENT_START_ON_BOOKED_END.name();
            } else if (bookedEnd.compareTo(currentEnd) == 0) {
                return BookingDateValidationString.CURRENT_END_ON_BOOKED_END.name();
            } else if (bookedStart.compareTo(currentStart) == 0) {
                return BookingDateValidationString.CURRENT_START_ON_BOOKED_START.name();
            }
        }
        return BookingDateValidationString.OK.name();
    }

}
