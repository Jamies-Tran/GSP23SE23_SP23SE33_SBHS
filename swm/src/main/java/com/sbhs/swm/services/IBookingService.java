package com.sbhs.swm.services;

import java.util.List;

import com.sbhs.swm.models.Booking;

public interface IBookingService {
    Booking createBookingForHomestay(Booking booking, String homestayName, List<String> homestayServices,
            long depositAmount);

    List<Booking> findBookingsByUsername(String username);

    Boolean canPassengerMakeBooking(long totalBookingPrice);

    Booking findBookingById(Long id);

    int checkBookingDate(String bookingStart, String bookingEnd, String homestayName, int totalBookingRoom);

}
