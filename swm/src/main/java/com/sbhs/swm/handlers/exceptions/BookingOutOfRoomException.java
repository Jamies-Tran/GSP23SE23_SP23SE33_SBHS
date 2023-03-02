package com.sbhs.swm.handlers.exceptions;

public class BookingOutOfRoomException extends InvalidException {

    public BookingOutOfRoomException() {
        super("Out of room");
    }

}
