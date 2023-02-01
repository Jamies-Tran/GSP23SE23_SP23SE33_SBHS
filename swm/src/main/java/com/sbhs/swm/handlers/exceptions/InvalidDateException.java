package com.sbhs.swm.handlers.exceptions;

public class InvalidDateException extends InvalidException {

    public InvalidDateException(String date) {
        super("Invalid date ".concat(date));
    }

}
