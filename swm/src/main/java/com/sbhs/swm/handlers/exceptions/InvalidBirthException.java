package com.sbhs.swm.handlers.exceptions;

public class InvalidBirthException extends InvalidException {

    public InvalidBirthException() {
        super("You must be older than 17 years old to have an account");

    }

}
