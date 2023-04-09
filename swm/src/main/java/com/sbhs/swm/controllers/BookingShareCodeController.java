package com.sbhs.swm.controllers;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sbhs.swm.dto.BookingInviteCodeDto;
import com.sbhs.swm.models.BookingInviteCode;
import com.sbhs.swm.services.IBookingInviteCodeService;

@RestController
@RequestMapping("/api/share-code")
public class BookingShareCodeController {
    @Autowired
    private IBookingInviteCodeService bookingShareCodeService;

    @Autowired
    private ModelMapper modelMapper;

    @PutMapping
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> applyBookingShareCode(String inviteCode) {
        BookingInviteCode bookingShareCode = bookingShareCodeService.applyBookingInviteCode(inviteCode);
        BookingInviteCodeDto responseShareCode = modelMapper.map(bookingShareCode, BookingInviteCodeDto.class);

        return new ResponseEntity<BookingInviteCodeDto>(responseShareCode, HttpStatus.OK);
    }
}
