package com.sbhs.swm.models;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
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
public class Booking extends BaseModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column
    private @Setter Long totalPrice;

    @Column
    private @Setter Long totalBookingDeposit;

    @Column
    private @Setter String status;

    @OneToOne(mappedBy = "booking")
    private @Setter TravelCart travelCart;

    @ManyToOne
    private @Setter Passenger passenger;

    @Column
    private @Setter String homestayType;
}
