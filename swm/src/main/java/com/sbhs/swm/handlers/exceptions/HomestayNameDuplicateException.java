package com.sbhs.swm.handlers.exceptions;

public class HomestayNameDuplicateException extends DuplicateException {

    public HomestayNameDuplicateException() {
        super("Homestay's name has been registered by another one");

    }

}
