package com.sbhs.swm.models;

import javax.persistence.Entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class PriceValuePromotion extends Promotion {
    private @Setter Long priceDiscount;

    private String type = "Price_Discount";
}
