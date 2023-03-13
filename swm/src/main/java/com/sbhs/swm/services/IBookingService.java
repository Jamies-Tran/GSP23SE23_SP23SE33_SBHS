package com.sbhs.swm.services;

import java.util.List;

import com.sbhs.swm.models.Booking;
import com.sbhs.swm.models.Homestay;

public interface IBookingService {
    Booking createBookingForHomestay(Booking booking, List<String> homestayServices,
            long depositAmount, List<String> homestayNames);

    List<Booking> findBookingsByUsername(String username);

    Boolean canPassengerMakeBooking(long totalBookingPrice);

    Booking findBookingById(Long id);

    List<Homestay> checkBlocBookingDate(String blocName, String bookingStart, String bookingEnd, int totalHomestay);

    // int checkBookingDate(String bookingStart, String bookingEnd, String
    // homestayName, int totalBookingRoom);

}
