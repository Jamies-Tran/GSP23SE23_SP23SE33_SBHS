package com.sbhs.swm.handlers.exceptions;

public class InvalidPromotionDateException extends InvalidException {

    public InvalidPromotionDateException() {
        super("Invalid promotion(check started date and expired date again)");

    }

}
