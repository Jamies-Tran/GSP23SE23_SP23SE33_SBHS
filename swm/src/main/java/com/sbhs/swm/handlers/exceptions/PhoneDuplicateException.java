package com.sbhs.swm.handlers.exceptions;

public class PhoneDuplicateException extends DuplicateException {

    public PhoneDuplicateException() {
        super("Phone exist");
    }

}
