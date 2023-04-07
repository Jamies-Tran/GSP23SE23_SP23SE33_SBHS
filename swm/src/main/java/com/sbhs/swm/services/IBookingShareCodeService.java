package com.sbhs.swm.services;

import com.sbhs.swm.models.BookingShareCode;

public interface IBookingShareCodeService {
    BookingShareCode getBookingSharedCodeByCode(String shareCode);

    BookingShareCode applyBookingShareCode(String shareCode);
}
