package com.sbhs.swm.handlers.exceptions;

public class UsernameNotFoundException extends NotFoundException {
    public UsernameNotFoundException(String username) {
        super("Can't find user ".concat(username));
    }
}
