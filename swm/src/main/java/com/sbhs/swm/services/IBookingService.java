package com.sbhs.swm.services;

import java.util.List;

import com.sbhs.swm.dto.request.BookingRequestDto;
import com.sbhs.swm.dto.request.TravelCartRequestDto;
import com.sbhs.swm.models.Booking;
import com.sbhs.swm.models.Homestay;
import com.sbhs.swm.models.TravelCart;

public interface IBookingService {
    // Booking createBookingForHomestay(List<BookingRequestDto> bookingRequestList);
    TravelCart addHomestayToPassengerTravelCart(TravelCartRequestDto travelCartRequest);

    List<Booking> findBookingsByUsername(String username);

    Boolean canPassengerMakeBooking(long totalBookingPrice);

    Booking findBookingById(Long id);

    List<Homestay> checkBlocBookingDate(String blocName, String bookingStart, String bookingEnd, int totalHomestay);

    // int checkBookingDate(String bookingStart, String bookingEnd, String
    // homestayName, int totalBookingRoom);

}
