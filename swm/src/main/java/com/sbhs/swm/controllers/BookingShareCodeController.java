package com.sbhs.swm.controllers;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sbhs.swm.dto.BookingShareCodeDto;
import com.sbhs.swm.models.BookingShareCode;
import com.sbhs.swm.services.IBookingShareCodeService;

@RestController
@RequestMapping("/api/share-code")
public class BookingShareCodeController {
    @Autowired
    private IBookingShareCodeService bookingShareCodeService;

    @Autowired
    private ModelMapper modelMapper;

    @PutMapping
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> applyBookingShareCode(String shareCode) {
        BookingShareCode bookingShareCode = bookingShareCodeService.applyBookingShareCode(shareCode);
        BookingShareCodeDto responseShareCode = modelMapper.map(bookingShareCode, BookingShareCodeDto.class);

        return new ResponseEntity<BookingShareCodeDto>(responseShareCode, HttpStatus.OK);
    }
}
