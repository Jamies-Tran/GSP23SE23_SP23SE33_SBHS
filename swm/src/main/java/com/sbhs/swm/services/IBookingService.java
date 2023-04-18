package com.sbhs.swm.services;

import java.util.List;

import org.springframework.beans.support.PagedListHolder;

import com.sbhs.swm.dto.request.BookingBlocHomestayRequestDto;
import com.sbhs.swm.dto.request.BookingHomestayRequestDto;
import com.sbhs.swm.dto.request.BookingUpdateRequestDto;
import com.sbhs.swm.dto.request.FilterBookingRequestDto;
import com.sbhs.swm.models.Booking;
import com.sbhs.swm.models.BookingHomestay;
import com.sbhs.swm.models.Homestay;

public interface IBookingService {

        BookingHomestay createSaveBookingForHomestay(BookingHomestayRequestDto bookingHomestayRequest);

        BookingHomestay updateBookingHomestayPaymentMethod(Long bookingId, Long homestayId, String paymentMethod);

        Booking updateSavedBooking(BookingUpdateRequestDto newBooking, Long bookingId);

        BookingHomestay checkInForHomestay(Long bookingId, Long homestayId);

        Booking checkInForBloc(Long bookingId);

        BookingHomestay checkOutForHomestay(Long bookingId, Long homestayId);

        Booking checkOutForBloc(Long bookingId);

        List<BookingHomestay> getLandlordBookingHomestayList(String homestayName, String status);

        Boolean isHomestayHaveBookingPending(String homestayName);

        Boolean isBlocHomestayHaveBookingPending(String blocName);

        Booking updateSavedBookingServices(List<Long> serviceIdList, String homestayName, Long bookingId);

        List<BookingHomestay> createSaveBookingForBloc(BookingBlocHomestayRequestDto bookingBlocHomestayRequest);

        void deleteBookingHomestay(Long bookingId, Long homestayId);

        void deleteBooking(Long bookingId);

        Booking createBookingByPassenger(String homestayType, String bookingFrom, String bookingTo);

        Booking submitBookingForHomestayByPassenger(Long bookingId);

        Booking submitBookingForBlocByPassenger(Long bookingId, String paymentMethod);

        BookingHomestay getBookingHomestayByHomestayId(Long homestayId);

        PagedListHolder<Booking> filterPassengerBooking(FilterBookingRequestDto filterBookingRequest,
                        int page, int size, boolean isNextPage, boolean isPreviousPage);

        List<Booking> filterPassengerBookingByHomestayType(List<Booking> bookingList, String homestayType);

        List<Booking> filterPassengerBookingByStatus(List<Booking> bookingList, String status);

        List<Booking> filterPassengerBookingByHost(boolean isHost);

        Boolean canPassengerMakeBooking(long totalBookingPrice);

        Booking findBookingById(Long id);

        Booking findBookingSavedBlocHomestayType();

        List<Homestay> getAvailableHomestayListFromBloc(String blocName, String bookingStart, String bookingEnd);

        boolean checkValidBookingForHomestay(String homestayName, String bookingStart, String bookingEnd,
                        int totalReservation);

        void addHomestayInBlocToBooking(String homestayName, Long bookingId, String paymentMethod);

        BookingHomestay acceptBookingForHomestay(Long bookingId, Long homestayId);

        BookingHomestay rejectBookingForHomestay(Long bookingId, Long homestayId, String message);

        Booking acceptBookingForBloc(Long bookingId);

        Booking rejectBookingForBloc(Long bookingId, String message);
}
