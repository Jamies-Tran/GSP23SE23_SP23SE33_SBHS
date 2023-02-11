package com.sbhs.swm.handlers.exceptions;

public class InvalidUserStatusException extends InvalidException {

    public InvalidUserStatusException() {
        super("Landlord account has been banned or not activated. Please contact admin@gmail.com for more support");

    }

}
