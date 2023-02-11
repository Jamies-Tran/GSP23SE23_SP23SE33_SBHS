package com.sbhs.swm.models;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class Promotion {
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
    private @Setter String startDate;

    @Column
    private @Setter String endDate;

    @Column
    private @Setter String status;

    @OneToOne(cascade = { CascadeType.PERSIST, CascadeType.REMOVE })
    @JoinColumn(name = "group_promotion_id", referencedColumnName = "id")
    private @Setter GroupHomestayPromotion groupHomestayPromotion;

    @OneToOne(cascade = { CascadeType.PERSIST, CascadeType.REMOVE })
    @JoinColumn(name = "homestay_promotion_id", referencedColumnName = "id")
    private @Setter HomestayPromotion homestayPromotion;

    @ManyToOne
    private @Setter Passenger passenger;

    @ManyToOne
    private @Setter Landlord landlord;

    @ManyToOne
    private @Setter Admin admin;

}
