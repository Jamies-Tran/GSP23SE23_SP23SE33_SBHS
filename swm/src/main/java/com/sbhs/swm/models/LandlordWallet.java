package com.sbhs.swm.models;

import java.util.List;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class LandlordWallet {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(mappedBy = "landlordWallet")
    private @Setter BalanceWallet landlordBalanceWallet;

    @OneToMany(mappedBy = "landlordWallet")
    private @Setter List<LandlordCommission> landlordCommissions;

    @OneToMany(mappedBy = "landlordWallet")
    private @Setter List<PaymentHistory> paymentHistories;
}
