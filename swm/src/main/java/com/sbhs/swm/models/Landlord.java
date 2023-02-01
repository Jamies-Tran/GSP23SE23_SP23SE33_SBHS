package com.sbhs.swm.models;

import java.util.List;

import javax.persistence.CascadeType;
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
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class Landlord {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(cascade = { CascadeType.PERSIST, CascadeType.REMOVE })
    private @Setter BalanceWallet landlordWallet;

    @OneToMany(mappedBy = "landlord")
    private @Setter List<PercentagePromotion> percentagePromotions;

    @OneToMany(mappedBy = "landlord")
    private @Setter List<PriceValuePromotion> priceValuePromotions;

    @OneToOne(mappedBy = "landlordProperty")
    private @Setter SwmUser user;
}
