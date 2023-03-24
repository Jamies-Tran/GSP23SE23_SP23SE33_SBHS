package com.sbhs.swm.services;

import java.util.List;

import com.sbhs.swm.dto.request.BookingBlocHomestayRequestDto;
import com.sbhs.swm.dto.request.BookingHomestayRequestDto;

import com.sbhs.swm.models.Booking;
import com.sbhs.swm.models.BookingHomestay;
import com.sbhs.swm.models.Homestay;

public interface IBookingService {

    BookingHomestay createSaveBookingForHomestay(BookingHomestayRequestDto bookingHomestayRequest);

    List<BookingHomestay> createSaveBookingForBloc(BookingBlocHomestayRequestDto bookingBlocHomestayRequest);

    Booking createBookingByPassenger();

    Booking submitBookingByPassenger(Long bookingId);

    BookingHomestay getBookingHomestayById(Long homestayId);

    List<Booking> findBookingsByUsernameAndStatus(String bookingStatus);

    List<Booking> findBookingsByHomestayNameAndStatus(String bookingStatus, String homestayName);

    Boolean canPassengerMakeBooking(long totalBookingPrice);

    Booking findBookingById(Long id);

    List<Homestay> getAvailableHomestayListFromBloc(String blocName, String bookingStart, String bookingEnd);

    public boolean checkValidBookingForHomestay(String homestayName, String bookingStart, String bookingEnd,
            int totalReservation);

}
