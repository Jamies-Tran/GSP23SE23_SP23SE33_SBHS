package com.sbhs.swm.controllers;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.sbhs.swm.dto.request.BookingBlocHomestayRequestDto;
import com.sbhs.swm.dto.request.BookingDateValidationRequestDto;
import com.sbhs.swm.dto.request.BookingHomestayRequestDto;
import com.sbhs.swm.dto.response.HomestayResponseDto;
import com.sbhs.swm.dto.response.BookingDateValidationResponseDto;
import com.sbhs.swm.dto.response.BookingHomestayResponseDto;
import com.sbhs.swm.dto.response.BookingResponseDto;
import com.sbhs.swm.models.Booking;
import com.sbhs.swm.models.BookingHomestay;
import com.sbhs.swm.models.Homestay;
import com.sbhs.swm.services.IBookingService;

@RestController
@RequestMapping("/api/booking")
public class BookingController {

    @Autowired
    private IBookingService bookingService;

    @Autowired
    private ModelMapper modelMapper;

    // @PostMapping("/new-booking")
    // @PreAuthorize("hasAuthority('booking:create')")
    // public ResponseEntity<?> createBooking(@RequestBody BookingRequestDto
    // bookingRequest) {
    // Booking booking = modelMapper.map(bookingRequest, Booking.class);
    // Booking savedBooking = bookingService.createBookingForHomestay(booking,
    // bookingRequest.getHomestayServicesString(),
    // bookingRequest.getDepositPaidAmount(), bookingRequest.getHomestayNames());
    // BookingResponseDto responseBooking = modelMapper.map(savedBooking,
    // BookingResponseDto.class);
    // responseBooking.getHomestay().setAddress(responseBooking.getHomestay().getAddress().split("_")[0]);

    // return new ResponseEntity<BookingResponseDto>(responseBooking,
    // HttpStatus.CREATED);
    // }

    @PostMapping("/new-booking")
    @PreAuthorize("hasAuthority('booking:create')")
    public ResponseEntity<?> createBookingByPassenger() {
        Booking bookingSave = bookingService.createBookingByPassenger();
        BookingResponseDto responseBookingSave = modelMapper.map(bookingSave, BookingResponseDto.class);

        return new ResponseEntity<BookingResponseDto>(responseBookingSave, HttpStatus.OK);

    }

    @PostMapping("/save-homestay")
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> createBookingHomestay(@RequestBody BookingHomestayRequestDto bookingHomestayRequest) {
        BookingHomestay bookingHomestay = bookingService.createSaveBookingForHomestay(bookingHomestayRequest);
        BookingHomestayResponseDto responseBookingHomestay = modelMapper.map(bookingHomestay,
                BookingHomestayResponseDto.class);

        return new ResponseEntity<BookingHomestayResponseDto>(responseBookingHomestay, HttpStatus.OK);
    }

    @PostMapping("/save-bloc")
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> createBookingBloc(@RequestBody BookingBlocHomestayRequestDto bookingBlocHomestayRequest) {
        List<BookingHomestay> bookingHomestayList = bookingService.createSaveBookingForBloc(bookingBlocHomestayRequest);
        List<BookingHomestayResponseDto> responseBookingHomestayList = bookingHomestayList.stream()
                .map(b -> modelMapper.map(b, BookingHomestayResponseDto.class)).collect(Collectors.toList());

        return new ResponseEntity<List<BookingHomestayResponseDto>>(responseBookingHomestayList, HttpStatus.OK);
    }

    @PutMapping("/submit")
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> submitBooking(Long bookingId) {
        Booking booking = bookingService.submitBookingByPassenger(bookingId);
        BookingResponseDto responseBooking = modelMapper.map(booking, BookingResponseDto.class);

        return new ResponseEntity<BookingResponseDto>(responseBooking, HttpStatus.OK);
    }

    @PostMapping("/validate-booking-date")
    public ResponseEntity<?> checkBookingDate(@RequestBody BookingDateValidationRequestDto validationBookingRequest) {
        List<Homestay> avaiblableHomestayList = bookingService.checkBlocBookingDate(
                validationBookingRequest.getBlocName(),
                validationBookingRequest.getBookingStart(), validationBookingRequest.getBookingEnd(),
                validationBookingRequest.getTotalBookingHomestays());
        List<HomestayResponseDto> responseHomestayList = avaiblableHomestayList.stream()
                .map(h -> modelMapper.map(h, HomestayResponseDto.class)).collect(Collectors.toList());
        BookingDateValidationResponseDto responseValidationBookingDate = new BookingDateValidationResponseDto(
                responseHomestayList);

        return new ResponseEntity<BookingDateValidationResponseDto>(responseValidationBookingDate, HttpStatus.OK);
    }

    @GetMapping("/booking-condition")
    @PreAuthorize("hasAuthority('booking:create')")
    public ResponseEntity<?> checkPassengerCanMakeBooking(@RequestParam Long totalBookingPrice) {
        Boolean canPassengerMakeBooking = bookingService.canPassengerMakeBooking(totalBookingPrice);

        return new ResponseEntity<Boolean>(canPassengerMakeBooking, HttpStatus.OK);
    }

    @GetMapping("/homestay-list")
    @PreAuthorize("hasRole(ROLE_LANDLORD)")
    public ResponseEntity<?> getBookingByHomestayNameAndStatus(String homestayName, String status) {
        List<Booking> bookings = bookingService.findBookingsByHomestayNameAndStatus(status, homestayName);
        List<BookingResponseDto> responseBookingList = bookings.stream()
                .map(b -> modelMapper.map(b, BookingResponseDto.class)).collect(Collectors.toList());

        return new ResponseEntity<List<BookingResponseDto>>(responseBookingList, HttpStatus.OK);

    }

    @GetMapping("/user-list")
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> getBookingByUsernameAndStatus(String status) {
        List<Booking> bookings = bookingService.findBookingsByUsernameAndStatus(status);
        List<BookingResponseDto> responseBookingList = bookings.stream()
                .map(b -> modelMapper.map(b, BookingResponseDto.class)).collect(Collectors.toList());

        return new ResponseEntity<List<BookingResponseDto>>(responseBookingList, HttpStatus.OK);
    }
}
