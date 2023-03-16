package com.sbhs.swm.services;

import java.util.List;

import com.sbhs.swm.dto.request.BookingHomestayRequestDto;

import com.sbhs.swm.models.Booking;
import com.sbhs.swm.models.BookingHomestay;
import com.sbhs.swm.models.Homestay;

public interface IBookingService {

    BookingHomestay createSaveBookingForHomestay(BookingHomestayRequestDto bookingHomestayRequest);

    Booking createBookingByPassenger();

    Booking submitBookingByPassenger(Long bookingId);

    List<Booking> findBookingsByUsernameAndStatus(String bookingStatus);

    List<Booking> findBookingsByHomestayNameAndStatus(String bookingStatus, String homestayName);

    Boolean canPassengerMakeBooking(long totalBookingPrice);

    Booking findBookingById(Long id);

    List<Homestay> checkBlocBookingDate(String blocName, String bookingStart, String bookingEnd, int totalHomestay);

    // int checkBookingDate(String bookingStart, String bookingEnd, String
    // homestayName, int totalBookingRoom);

}
