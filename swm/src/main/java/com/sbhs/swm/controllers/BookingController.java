package com.sbhs.swm.controllers;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sbhs.swm.dto.request.BookingRequestDto;
import com.sbhs.swm.dto.request.BookingDateValidationRequestDto;
import com.sbhs.swm.dto.response.BookingResponseDto;
import com.sbhs.swm.dto.response.BookingDateValidationResponseDto;
import com.sbhs.swm.models.Booking;
import com.sbhs.swm.services.IBookingService;

@RestController
@RequestMapping("/api/booking")
public class BookingController {

    @Autowired
    private IBookingService bookingService;

    @Autowired
    private ModelMapper modelMapper;

    @PostMapping("/new-booking")
    @PreAuthorize("hasAuthority('booking:create')")
    public ResponseEntity<?> createBooking(@RequestBody BookingRequestDto bookingRequest) {
        Booking booking = modelMapper.map(bookingRequest, Booking.class);
        Booking savedBooking = bookingService.createBooking(booking, bookingRequest.getHomestayName(),
                bookingRequest.getHomestayServicesString());
        BookingResponseDto responseBooking = modelMapper.map(savedBooking, BookingResponseDto.class);
        responseBooking.getHomestay().setAddress(responseBooking.getHomestay().getAddress().split("-")[0]);

        return new ResponseEntity<BookingResponseDto>(responseBooking, HttpStatus.CREATED);
    }

    @PostMapping("/validate-booking-date")
    public ResponseEntity<?> checkBookingDate(@RequestBody BookingDateValidationRequestDto validationBookingRequest) {
        int avaiblableRoom = bookingService.checkBookingDate(validationBookingRequest.getBookingStart(),
                validationBookingRequest.getBookingEnd(), validationBookingRequest.getHomestayName(),
                validationBookingRequest.getTotalBookingRoom());
        BookingDateValidationResponseDto responseValidationBookingDate = new BookingDateValidationResponseDto(
                avaiblableRoom);

        return new ResponseEntity<BookingDateValidationResponseDto>(responseValidationBookingDate, HttpStatus.OK);
    }
}
