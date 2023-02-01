package com.sbhs.swm.services;

import java.util.List;

import com.sbhs.swm.models.Booking;

public interface IBookingService {
    List<Booking> findBookingsByUsername(String username);

    Booking findBookingById(Long id);
}
