package com.sbhs.swm.handlers.exceptions;

public class PasswordModificationException extends RuntimeException {
    public PasswordModificationException() {
        super("Unable to change password");
    }
}
