package com.sbhs.swm.services;

import java.util.List;

import com.sbhs.swm.dto.request.BookingBlocHomestayRequestDto;
import com.sbhs.swm.dto.request.BookingHomestayRequestDto;
import com.sbhs.swm.dto.request.BookingUpdateRequestDto;
import com.sbhs.swm.models.Booking;
import com.sbhs.swm.models.BookingHomestay;
import com.sbhs.swm.models.Homestay;

public interface IBookingService {

    BookingHomestay createSaveBookingForHomestay(BookingHomestayRequestDto bookingHomestayRequest);

    Booking updateSavedBooking(BookingUpdateRequestDto newBooking, Long bookingId);

    Booking updateSavedBookingServices(List<String> serviceNameList, String homestayName, Long bookingId);

    List<BookingHomestay> createSaveBookingForBloc(BookingBlocHomestayRequestDto bookingBlocHomestayRequest);

    void deleteBookingHomestay(Long bookingId, Long homestayId);

    void deleteBooking(Long bookingId);

    Booking createBookingByPassenger(String homestayType, String bookingFrom, String bookingTo);

    Booking submitBookingForHomestayByPassenger(Long bookingId);

    Booking submitBookingForBlocByPassenger(Long bookingId, String paymentMethod);

    BookingHomestay getBookingHomestayByHomestayId(Long homestayId);

    List<Booking> findBookingsByUsernameAndStatus(String bookingStatus);

    List<Booking> findBookingsByHomestayNameAndStatus(String bookingStatus, String homestayName);

    Boolean canPassengerMakeBooking(long totalBookingPrice);

    Booking findBookingById(Long id);

    Booking findBookingSavedBlocHomestayType();

    List<Homestay> getAvailableHomestayListFromBloc(String blocName, String bookingStart, String bookingEnd);

    boolean checkValidBookingForHomestay(String homestayName, String bookingStart, String bookingEnd,
            int totalReservation);

    void addHomestayInBlocToBooking(String homestayName, Long bookingId, String paymentMethod);
}
