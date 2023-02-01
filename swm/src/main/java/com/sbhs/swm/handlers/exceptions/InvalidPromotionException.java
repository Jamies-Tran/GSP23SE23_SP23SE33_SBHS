package com.sbhs.swm.handlers.exceptions;

public class InvalidPromotionException extends InvalidException {

    public InvalidPromotionException() {
        super("Invalid promotion(check started date and expired date again)");

    }

}
