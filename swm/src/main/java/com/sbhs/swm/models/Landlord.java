package com.sbhs.swm.models;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
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

    @OneToMany(mappedBy = "landlord")
    private @Setter List<Promotion> promotions;

    @OneToOne
    @JoinColumn(name = "group_promotion_id", referencedColumnName = "id")
    private @Setter GroupHomestayPromotion availableGroupHomestayPromotion;

    @Column
    private @Setter String idCardImageUrl;

    @OneToOne(cascade = { CascadeType.PERSIST, CascadeType.REMOVE })
    @JoinColumn(name = "landlord_wallet_id", referencedColumnName = "id")
    private @Setter BalanceWallet landlordWallet;

    @OneToOne(mappedBy = "landlordProperty")
    private @Setter SwmUser user;
}
