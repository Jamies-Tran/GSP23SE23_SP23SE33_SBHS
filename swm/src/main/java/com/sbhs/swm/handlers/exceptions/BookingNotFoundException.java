package com.sbhs.swm.handlers.exceptions;

public class BookingNotFoundException extends NotFoundException {

    public BookingNotFoundException() {
        super("Id booking not found");
    }

}
