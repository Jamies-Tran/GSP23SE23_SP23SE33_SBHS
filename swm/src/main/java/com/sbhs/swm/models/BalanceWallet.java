package com.sbhs.swm.models;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
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
    private double totalBalance;

    @Column
    private double availableBalance;

    @OneToOne(mappedBy = "passengerWallet")
    private @Setter Passenger passenger;

    @OneToOne(mappedBy = "landlordWallet")
    private @Setter Landlord landlord;
}
