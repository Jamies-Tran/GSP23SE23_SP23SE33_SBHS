package com.sbhs.swm.handlers.exceptions;

public class EmailNotFoundException extends NotFoundException {

    public EmailNotFoundException() {
        super("Email can't be found");

    }

}
