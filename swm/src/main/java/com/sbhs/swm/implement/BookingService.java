package com.sbhs.swm.implement;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Service;

import com.sbhs.swm.handlers.exceptions.BookingNotFoundException;
import com.sbhs.swm.models.Booking;
import com.sbhs.swm.repositories.BookingRepo;
import com.sbhs.swm.services.IBookingService;

@Service
public class BookingService implements IBookingService {

    @Autowired
    private BookingRepo bookingRepo;

    @Override
    public List<Booking> findBookingsByUsername(String username) {
        List<Booking> bookings = bookingRepo.findBookingListByUsername(username);

        return bookings;
    }

    @Override
    public Booking findBookingById(Long id) {
        Booking booking = bookingRepo.findById(id).orElseThrow(() -> new BookingNotFoundException());

        return booking;
    }

}
