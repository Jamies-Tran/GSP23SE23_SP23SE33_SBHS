package com.sbhs.swm.services;

import java.util.List;

import com.sbhs.swm.models.Booking;

public interface IBookingService {
    Booking createBooking(Booking booking, String homestayName, List<String> homestayServices);

    List<Booking> findBookingsByUsername(String username);

    Booking findBookingById(Long id);

    String checkBookingDate(String startDate, String endDate, String homestayName);
}
