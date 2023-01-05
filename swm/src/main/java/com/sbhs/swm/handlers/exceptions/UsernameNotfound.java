package com.sbhs.swm.handlers.exceptions;

public class UsernameNotfound extends RuntimeException {
    public UsernameNotfound(String username) {
        super("Can't find user with username ".concat(username));
    }
}
