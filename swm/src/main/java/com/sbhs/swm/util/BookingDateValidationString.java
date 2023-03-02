package com.sbhs.swm.util;

public enum BookingDateValidationString {
    OK,
    INVALID,
    CURRENT_START_ON_BOOKED_END,
    CURRENT_END_ON_BOOKED_END,
    CURRENT_START_ON_BOOKED_START,
    ON_BOOKING_PERIOD
}
