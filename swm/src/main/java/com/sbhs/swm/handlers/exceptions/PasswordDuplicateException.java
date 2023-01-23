package com.sbhs.swm.handlers.exceptions;

public class PasswordDuplicateException extends DuplicateException {

    public PasswordDuplicateException() {
        super("Can't change to old password");
    }

}
