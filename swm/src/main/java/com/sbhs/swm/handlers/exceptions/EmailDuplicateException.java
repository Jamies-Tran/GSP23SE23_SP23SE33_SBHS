package com.sbhs.swm.handlers.exceptions;

public class EmailDuplicateException extends DuplicateException {

    public EmailDuplicateException() {
        super("Email exist");
    }

}
