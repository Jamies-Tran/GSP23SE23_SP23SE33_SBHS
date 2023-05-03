package com.sbhs.swm.controllers;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.support.PagedListHolder;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.sbhs.swm.dto.paging.BookingListPagingDto;
import com.sbhs.swm.dto.request.BookingBlocHomestayRequestDto;
import com.sbhs.swm.dto.request.BookingDateValidationRequestDto;
import com.sbhs.swm.dto.request.BookingHomestayRequestDto;
import com.sbhs.swm.dto.request.BookingUpdateRequestDto;
import com.sbhs.swm.dto.request.FilterBookingRequestDto;
import com.sbhs.swm.dto.response.HomestayResponseDto;
import com.sbhs.swm.dto.response.BlocHomestayResponseDto;
import com.sbhs.swm.dto.response.BookingDateValidationResponseDto;
import com.sbhs.swm.dto.response.BookingHomestayListResponseDto;
import com.sbhs.swm.dto.response.BookingHomestayResponseDto;
import com.sbhs.swm.dto.response.BookingHomestayResponseForLandlordDto;
import com.sbhs.swm.dto.response.BookingInviteCodeResponseDto;
import com.sbhs.swm.dto.response.BookingResponseDto;
import com.sbhs.swm.dto.response.BookingResponseForLandlordDto;
import com.sbhs.swm.models.Booking;
import com.sbhs.swm.models.BookingHomestay;

import com.sbhs.swm.models.Homestay;
import com.sbhs.swm.models.type.HomestayType;
import com.sbhs.swm.services.IBookingService;

import io.swagger.annotations.Authorization;

@RestController
@RequestMapping("/api/booking")
public class BookingController {

    @Autowired
    private IBookingService bookingService;

    @Autowired
    private ModelMapper modelMapper;

    @PostMapping("/new-booking")
    @PreAuthorize("hasAuthority('booking:create')")
    public ResponseEntity<?> createBookingByPassenger(String homestayType, String bookingFrom, String bookingTo) {
        Booking bookingSave = bookingService.createBookingByPassenger(homestayType, bookingFrom, bookingTo);
        BookingResponseDto responseBookingSave = modelMapper.map(bookingSave, BookingResponseDto.class);
        responseBookingSave.setBookingHomestays(new ArrayList<>());
        responseBookingSave.setBookingHomestayServices(new ArrayList<>());

        return new ResponseEntity<BookingResponseDto>(responseBookingSave, HttpStatus.OK);

    }

    @GetMapping("/booking-homestay")
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> getBookingHomestayByHomestayId(Long homestayId) {
        BookingHomestay bookingHomestay = bookingService.getBookingHomestayByHomestayId(homestayId);
        BookingHomestayResponseDto responseBookingHomestay = modelMapper.map(bookingHomestay,
                BookingHomestayResponseDto.class);

        return new ResponseEntity<BookingHomestayResponseDto>(responseBookingHomestay, HttpStatus.OK);
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('ROLE_PASSENGER', 'ROLE_LANDLORD')")
    public ResponseEntity<?> getBookingById(Long bookingId) {
        Booking booking = bookingService.findBookingById(bookingId);
        BookingResponseDto responseBooking = modelMapper.map(booking, BookingResponseDto.class);
        switch (HomestayType.valueOf(booking.getHomestayType().toUpperCase())) {
            case BLOC:
                BlocHomestayResponseDto responseBlocHomestay = modelMapper.map(booking.getBloc(),
                        BlocHomestayResponseDto.class);
                responseBooking.setBlocResponse(responseBlocHomestay);
                break;
            case HOMESTAY:
                break;
        }

        for (BookingHomestayResponseDto b : responseBooking.getBookingHomestays()) {
            b.getHomestay().setAddress(b.getHomestay().getAddress().split("_")[0]);
        }

        return new ResponseEntity<BookingResponseDto>(responseBooking, HttpStatus.OK);
    }

    @PostMapping("/save-homestay")
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> createBookingHomestay(@RequestBody BookingHomestayRequestDto bookingHomestayRequest) {
        BookingHomestay bookingHomestay = bookingService.createSaveBookingForHomestay(bookingHomestayRequest);
        BookingHomestayResponseDto responseBookingHomestay = modelMapper.map(bookingHomestay,
                BookingHomestayResponseDto.class);

        return new ResponseEntity<BookingHomestayResponseDto>(responseBookingHomestay, HttpStatus.OK);
    }

    @GetMapping("/bloc-type")
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> getBookingSavedBlocHomestayType() {
        Booking booking = bookingService.findBookingSavedBlocHomestayType();
        BookingResponseDto responseBooking = modelMapper.map(booking, BookingResponseDto.class);
        // BlocHomestayResponseDto responseBloc = modelMapper.map(booking.getBloc(),
        // BlocHomestayResponseDto.class);
        // responseBooking.setBlocResponse(responseBloc);
        // responseBooking.getBlocResponse().setAddress(responseBooking.getBlocResponse().getAddress().split("_")[0]);

        return new ResponseEntity<BookingResponseDto>(responseBooking, HttpStatus.OK);
    }

    @GetMapping("/landlord/homestay/booking-list")
    @PreAuthorize("hasRole('ROLE_LANDLORD')")
    public ResponseEntity<?> getBookingHomestayForLandlord(String homestayName, String status) {
        List<BookingHomestay> bookingHomestayList = bookingService.getLandlordBookingHomestayList(homestayName, status);
        List<BookingHomestayResponseForLandlordDto> responseBookingList = bookingHomestayList.stream()
                .map(h -> modelMapper.map(h, BookingHomestayResponseForLandlordDto.class)).collect(Collectors.toList());
        responseBookingList.forEach(b -> b.getHomestay().setAddress(b.getHomestay().getAddress().split("_")[0]));
        BookingHomestayListResponseDto responseBookingHomestayList = new BookingHomestayListResponseDto();
        responseBookingHomestayList.setBookingList(responseBookingList);

        return new ResponseEntity<BookingHomestayListResponseDto>(responseBookingHomestayList, HttpStatus.OK);
    }

    @GetMapping("/landlord/bloc/booking-list")
    @PreAuthorize("hasRole('ROLE_LANDLORD')")
    public ResponseEntity<?> getBookingBlocForLandlord(String blocName, String status) {
        List<Booking> bookingList = bookingService.getLandlordBookingBlocList(blocName, status);
        List<BookingResponseForLandlordDto> responseBookingList = bookingList.stream()
                .map(h -> modelMapper.map(h, BookingResponseForLandlordDto.class)).collect(Collectors.toList());
        responseBookingList.forEach(b -> b.getBloc().setAddress(b.getBloc().getAddress().split("_")[0]));

        return new ResponseEntity<List<BookingResponseForLandlordDto>>(responseBookingList, HttpStatus.OK);
    }

    @PutMapping
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> updateBooking(@RequestBody BookingUpdateRequestDto booking, @RequestParam Long bookingId) {

        Booking updatedBooking = bookingService.updateSavedBooking(booking, bookingId);
        BookingResponseDto responseBooking = modelMapper.map(updatedBooking, BookingResponseDto.class);

        return new ResponseEntity<BookingResponseDto>(responseBooking, HttpStatus.OK);
    }

    @PutMapping("/homestay-in-bloc")
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> addHomestayInBlocToBooking(String homestayName, Long bookingId, String paymentMethod) {
        bookingService.addHomestayInBlocToBooking(homestayName, bookingId, paymentMethod);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PutMapping("/homestay-service")
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> updateBookingServices(@RequestBody List<Long> serviceIdList,
            @RequestParam Long bookingId, @RequestParam String homestayName) {
        Booking updatedBookingService = bookingService.updateSavedBookingServices(serviceIdList, homestayName,
                bookingId);
        BookingResponseDto responseBooking = modelMapper.map(updatedBookingService, BookingResponseDto.class);

        return new ResponseEntity<BookingResponseDto>(responseBooking, HttpStatus.OK);

    }

    @PostMapping("/save-bloc")
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> createBookingBloc(@RequestBody BookingBlocHomestayRequestDto bookingBlocHomestayRequest) {
        List<BookingHomestay> bookingHomestayList = bookingService.createSaveBookingForBloc(bookingBlocHomestayRequest);
        List<BookingHomestayResponseDto> responseBookingHomestayList = bookingHomestayList.stream()
                .map(b -> modelMapper.map(b, BookingHomestayResponseDto.class)).collect(Collectors.toList());

        return new ResponseEntity<List<BookingHomestayResponseDto>>(responseBookingHomestayList, HttpStatus.OK);
    }

    @PutMapping("/submit-homestay")
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> submitBookingForHomestay(Long bookingId) {
        Booking booking = bookingService.submitBookingForHomestayByPassenger(bookingId);
        BookingResponseDto responseBooking = modelMapper.map(booking, BookingResponseDto.class);

        return new ResponseEntity<BookingResponseDto>(responseBooking, HttpStatus.OK);
    }

    @PutMapping("/submit-bloc")
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> submitBookingForBloc(Long bookingId, String paymentMethod) {
        Booking booking = bookingService.submitBookingForBlocByPassenger(bookingId, paymentMethod);
        BookingResponseDto responseBooking = modelMapper.map(booking, BookingResponseDto.class);

        return new ResponseEntity<BookingResponseDto>(responseBooking, HttpStatus.OK);
    }

    @PostMapping("/user/bloc-available-homestays")
    public ResponseEntity<?> getAvalableHomestayInBloc(
            @RequestBody BookingDateValidationRequestDto validationBookingRequest) {
        List<Homestay> avaiblableHomestayList = bookingService.getAvailableHomestayListFromBloc(
                validationBookingRequest.getHomestayName(),
                validationBookingRequest.getBookingStart(), validationBookingRequest.getBookingEnd());
        List<HomestayResponseDto> responseHomestayList = avaiblableHomestayList.stream()
                .map(h -> modelMapper.map(h, HomestayResponseDto.class)).collect(Collectors.toList());
        BookingDateValidationResponseDto responseValidationBookingDate = new BookingDateValidationResponseDto(
                responseHomestayList);

        return new ResponseEntity<BookingDateValidationResponseDto>(responseValidationBookingDate, HttpStatus.OK);
    }

    @PostMapping("/user/available-date")
    public ResponseEntity<?> checkHomestayAvalableAtBookingDate(
            @RequestBody BookingDateValidationRequestDto bookingValidateRequest) {
        Boolean isValid = bookingService.checkValidBookingForHomestay(bookingValidateRequest.getHomestayName(),
                bookingValidateRequest.getBookingStart(),
                bookingValidateRequest.getBookingEnd(), bookingValidateRequest.getTotalReservation());
        if (isValid) {
            return new ResponseEntity<>(HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.CONFLICT);
        }
    }

    @GetMapping("/booking-condition")
    @PreAuthorize("hasAuthority('booking:create')")
    public ResponseEntity<?> checkPassengerCanMakeBooking(@RequestParam Long totalBookingPrice) {
        Boolean canPassengerMakeBooking = bookingService.canPassengerMakeBooking(totalBookingPrice);

        return new ResponseEntity<Boolean>(canPassengerMakeBooking, HttpStatus.OK);
    }

    @PutMapping("/homestay/accept")
    @Authorization("hasRole('ROLE_LANDLORD')")
    public ResponseEntity<?> acceptBookingForHomestay(Long bookingId, Long homestayId) {
        BookingHomestay bookingHomestay = bookingService.acceptBookingForHomestay(bookingId, homestayId);
        BookingHomestayResponseDto responseBookingHomestay = modelMapper.map(bookingHomestay,
                BookingHomestayResponseDto.class);
        responseBookingHomestay.getHomestay()
                .setAddress(responseBookingHomestay.getHomestay().getAddress().split("-")[0]);
        return new ResponseEntity<BookingHomestayResponseDto>(responseBookingHomestay, HttpStatus.OK);
    }

    @PutMapping("/homestay/reject")
    @Authorization("hasRole('ROLE_LANDLORD')")
    public ResponseEntity<?> rejectBookingForHomestay(Long bookingId, Long homestayId, @RequestBody String message) {
        BookingHomestay bookingHomestay = bookingService.rejectBookingForHomestay(bookingId, homestayId, message);
        BookingHomestayResponseDto responseBookingHomestay = modelMapper.map(bookingHomestay,
                BookingHomestayResponseDto.class);
        responseBookingHomestay.getHomestay()
                .setAddress(responseBookingHomestay.getHomestay().getAddress().split("_")[0]);
        return new ResponseEntity<BookingHomestayResponseDto>(responseBookingHomestay, HttpStatus.OK);
    }

    @PutMapping("/bloc/accept")
    @Authorization("hasRole('ROLE_LANDLORD')")
    public ResponseEntity<?> acceptBookingForBloc(Long bookingId) {
        Booking booking = bookingService.acceptBookingForBloc(bookingId);
        BlocHomestayResponseDto bloc = modelMapper.map(booking.getBloc(), BlocHomestayResponseDto.class);
        bloc.setAddress(bloc.getAddress().split("_")[0]);
        BookingResponseDto responseBooking = modelMapper.map(booking, BookingResponseDto.class);
        responseBooking.setBlocResponse(bloc);

        return new ResponseEntity<BookingResponseDto>(responseBooking, HttpStatus.OK);
    }

    @PutMapping("/bloc/reject")
    @Authorization("hasRole('ROLE_LANDLORD')")
    public ResponseEntity<?> rejectBookingForBloc(Long bookingId, @RequestBody String message) {
        Booking booking = bookingService.rejectBookingForBloc(bookingId, message);
        BlocHomestayResponseDto bloc = modelMapper.map(booking.getBloc(), BlocHomestayResponseDto.class);
        bloc.setAddress(bloc.getAddress().split("_")[0]);
        BookingResponseDto responseBooking = modelMapper.map(booking,
                BookingResponseDto.class);
        responseBooking.setBlocResponse(bloc);

        return new ResponseEntity<BookingResponseDto>(responseBooking, HttpStatus.OK);
    }

    @PutMapping("/homestay/payment-method")
    @Authorization("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> updateBookingHomestayPaymentMethod(Long bookingId, Long homestayId, String paymentMethod) {
        BookingHomestay bookingHomestay = bookingService.updateBookingHomestayPaymentMethod(bookingId, homestayId,
                paymentMethod);
        BookingHomestayResponseDto responseBookingHomestay = modelMapper.map(bookingHomestay,
                BookingHomestayResponseDto.class);

        return new ResponseEntity<BookingHomestayResponseDto>(responseBookingHomestay, HttpStatus.OK);
    }

    // @GetMapping("/homestay-list")
    // @PreAuthorize("hasRole(ROLE_LANDLORD)")
    // public ResponseEntity<?> getBookingByHomestayNameAndStatus(String
    // homestayName, String status) {
    // List<Booking> bookings =
    // bookingService.findBookingsByHomestayNameAndStatus(status, homestayName);
    // List<BookingResponseDto> responseBookingList = bookings.stream()
    // .map(b -> modelMapper.map(b,
    // BookingResponseDto.class)).collect(Collectors.toList());

    // return new ResponseEntity<List<BookingResponseDto>>(responseBookingList,
    // HttpStatus.OK);

    // }

    // @GetMapping("/user-list")
    // @PreAuthorize("hasRole('ROLE_PASSENGER')")
    // public ResponseEntity<?> getBookingByUsernameAndStatus(String status) {
    // List<Booking> bookings =
    // bookingService.findBookingsByUsernameAndStatus(status);
    // List<BookingResponseDto> responseBookingList = bookings.stream()
    // .map(b -> modelMapper.map(b,
    // BookingResponseDto.class)).collect(Collectors.toList());

    // return new ResponseEntity<List<BookingResponseDto>>(responseBookingList,
    // HttpStatus.OK);
    // }

    @DeleteMapping("/booking-homestay")
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> deleteBookingHomestay(Long bookingId, Long homestayId) {
        bookingService.deleteBookingHomestay(bookingId, homestayId);

        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    @DeleteMapping
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> deleteBooking(Long bookingId) {
        bookingService.deleteBooking(bookingId);

        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    @PostMapping("/filter-booking")
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> filterPassengerBooking(@RequestBody FilterBookingRequestDto filterBookingRequest, int page,
            int size, Boolean isNextPage, Boolean isPreviousPage) {
        PagedListHolder<Booking> bookingList = bookingService.filterPassengerBooking(filterBookingRequest, page, size,
                isNextPage, isPreviousPage);
        List<BookingResponseDto> responseBookingList = bookingList.getPageList().stream()
                .map(b -> modelMapper.map(b, BookingResponseDto.class)).collect(Collectors.toList());
        BookingListPagingDto bookingListPaging = new BookingListPagingDto();
        bookingListPaging.setBookings(responseBookingList);
        bookingListPaging.setPageNumber(bookingList.getPage());

        return new ResponseEntity<BookingListPagingDto>(bookingListPaging, HttpStatus.OK);
    }

    @PutMapping("/homestay/check-in")
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> checkInForHomestay(Long bookingId, Long homestayId) {
        BookingHomestay bookingHomestay = bookingService.checkInForHomestay(bookingId, homestayId);
        BookingHomestayResponseDto responseBookingHomestay = modelMapper.map(bookingHomestay,
                BookingHomestayResponseDto.class);

        return new ResponseEntity<BookingHomestayResponseDto>(responseBookingHomestay, HttpStatus.OK);
    }

    @PutMapping("/homestay/cancel")
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> cancelBookingHomestay(Long bookingId, Long homestayId) {
        BookingHomestay bookingHomestay = bookingService.cancelBookingHomestay(bookingId, homestayId, false);
        BookingHomestayResponseDto responseBookingHomestay = modelMapper.map(bookingHomestay,
                BookingHomestayResponseDto.class);

        return new ResponseEntity<BookingHomestayResponseDto>(responseBookingHomestay, HttpStatus.OK);
    }

    @PutMapping("/bloc/cancel")
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> cancelBookingBloc(Long bookingId) {
        Booking booking = bookingService.cancelBookingBloc(bookingId, false);
        BookingResponseDto responseBooking = modelMapper.map(booking,
                BookingResponseDto.class);

        return new ResponseEntity<BookingResponseDto>(responseBooking, HttpStatus.OK);
    }

    @PutMapping("/homestay/check-out")
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> checkOutForHomestay(Long bookingId, Long homestayId) {
        BookingHomestay bookingHomestay = bookingService.checkOutForHomestay(bookingId, homestayId);
        BookingHomestayResponseDto responseBookingHomestay = modelMapper.map(bookingHomestay,
                BookingHomestayResponseDto.class);

        return new ResponseEntity<BookingHomestayResponseDto>(responseBookingHomestay, HttpStatus.OK);
    }

    @PutMapping("/bloc/check-in")
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> checkInForBloc(Long bookingId) {
        Booking booking = bookingService.checkInForBloc(bookingId);
        BookingResponseDto responseBooking = modelMapper.map(booking,
                BookingResponseDto.class);
        BookingInviteCodeResponseDto bookingInviteCode = modelMapper.map(booking.getInviteCode(),
                BookingInviteCodeResponseDto.class);
        BlocHomestayResponseDto resposneBloc = modelMapper.map(booking.getBloc(), BlocHomestayResponseDto.class);
        responseBooking.setBlocResponse(resposneBloc);
        responseBooking.setInviteCode(bookingInviteCode);

        return new ResponseEntity<BookingResponseDto>(responseBooking, HttpStatus.OK);
    }

    @PutMapping("/bloc/check-out")
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> checkOutForBloc(Long bookingId) {
        Booking booking = bookingService.checkOutForBloc(bookingId);
        BookingResponseDto responseBooking = modelMapper.map(booking,
                BookingResponseDto.class);
        BookingInviteCodeResponseDto bookingInviteCode = modelMapper.map(booking.getInviteCode(),
                BookingInviteCodeResponseDto.class);
        BlocHomestayResponseDto resposneBloc = modelMapper.map(booking.getBloc(), BlocHomestayResponseDto.class);
        responseBooking.setBlocResponse(resposneBloc);
        responseBooking.setInviteCode(bookingInviteCode);

        return new ResponseEntity<BookingResponseDto>(responseBooking, HttpStatus.OK);
    }
}
