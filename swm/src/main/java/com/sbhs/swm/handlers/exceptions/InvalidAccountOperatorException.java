package com.sbhs.swm.handlers.exceptions;

public class InvalidAccountOperatorException extends InvalidException {

    public InvalidAccountOperatorException() {
        super("Your account is not activate. Please wait for admin approval.");

    }

}
