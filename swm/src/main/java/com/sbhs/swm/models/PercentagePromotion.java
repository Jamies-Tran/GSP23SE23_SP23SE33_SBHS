package com.sbhs.swm.models;

import javax.persistence.Column;
import javax.persistence.Entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class PercentagePromotion extends Promotion {

    @Column
    private double percentageDiscount;

    @Column
    private String type = "Percentage_Discount";

}
