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
public class PaymentHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column
    private @Setter String createdDate;

    @Column(unique = true)
    private @Setter String orderId;

    @Column
    private @Setter Long amount;

    @Column
    private @Setter String paymentMethod;

    @ManyToOne
    private @Setter PassengerWallet passengerWallet;

    @ManyToOne
    private @Setter LandlordWallet landlordWallet;
}
