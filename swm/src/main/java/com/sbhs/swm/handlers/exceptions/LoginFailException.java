package com.sbhs.swm.handlers.exceptions;

public class LoginFailException extends RuntimeException {
    public LoginFailException() {
        super("Username or password incorrect");
    }
}
