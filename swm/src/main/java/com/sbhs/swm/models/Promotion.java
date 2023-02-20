package com.sbhs.swm.models;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import javax.persistence.ManyToOne;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class Promotion extends BaseModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true)
    private @Setter String code;

    @Column
    private @Setter Long discountAmount;

    @Column
    private @Setter String discountType;

    @Column
    private @Setter String promotionType;

    @Column
    private @Setter String startDate;

    @Column
    private @Setter String endDate;

    @Column
    private @Setter String status;

    @ManyToOne
    private @Setter Passenger passenger;

    @ManyToOne
    private @Setter Landlord landlord;

    @ManyToOne
    private @Setter Admin admin;

    @ManyToOne
    private @Setter Homestay homestay;
}
