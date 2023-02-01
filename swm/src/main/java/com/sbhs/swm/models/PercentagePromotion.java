package com.sbhs.swm.models;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.ManyToOne;

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
    private double discountPercentage;

    @Column
    private String type = "Percentage_Discount";

    @ManyToOne
    private @Setter Passenger passenger;

    @ManyToOne
    private @Setter Landlord landlord;

    @ManyToOne
    private @Setter Admin admin;
}
