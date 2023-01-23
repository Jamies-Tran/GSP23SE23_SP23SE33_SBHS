package com.sbhs.swm.handlers.exceptions;

public class VerifyPassModificationFailException extends RuntimeException {
    public VerifyPassModificationFailException() {
        super("Invalid otp");
    }
}
