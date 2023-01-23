package com.sbhs.swm.handlers.exceptions;

public class UsernameDuplicateException extends DuplicateException {

    public UsernameDuplicateException() {
        super("Username exist");
    }

}
