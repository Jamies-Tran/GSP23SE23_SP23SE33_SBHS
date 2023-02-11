package com.sbhs.swm.models;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class BalanceWallet {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column
    private @Setter long totalBalance = 0;

    @OneToOne(mappedBy = "passengerWallet")
    private @Setter Passenger passenger;

    @OneToOne(mappedBy = "landlordWallet")
    private @Setter Landlord landlord;

    @OneToOne(cascade = { CascadeType.PERSIST, CascadeType.REMOVE })
    @JoinColumn(name = "passenger_wallet_id", referencedColumnName = "id")
    private @Setter PassengerWallet passengerWallet;

}
