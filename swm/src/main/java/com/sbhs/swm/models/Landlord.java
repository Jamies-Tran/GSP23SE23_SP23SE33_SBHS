package com.sbhs.swm.models;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;

import com.sbhs.swm.models.status.LandlordStatus;

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

    @Column
    private @Setter String status = LandlordStatus.NOT_ACTIVATED.name();

    @OneToOne(cascade = { CascadeType.PERSIST, CascadeType.REMOVE })
    private @Setter BalanceWallet landlordWallet;

    @OneToMany(mappedBy = "landlord")
    private @Setter List<Promotion> promotions;

    @OneToOne
    private @Setter GroupHomestayPromotion availableGroupHomestayPromotion;

    @OneToOne(mappedBy = "landlordProperty")
    private @Setter SwmUser user;
}
