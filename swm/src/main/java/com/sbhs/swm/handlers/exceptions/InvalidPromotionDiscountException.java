package com.sbhs.swm.handlers.exceptions;

public class InvalidPromotionDiscountException extends InvalidException {

    public InvalidPromotionDiscountException() {
        super("Discount must be greater than 0");
    }

}
