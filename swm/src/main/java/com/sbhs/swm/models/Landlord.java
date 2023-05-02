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
public class Landlord extends BaseModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column
    private @Setter String status = LandlordStatus.PENDING.name();

    @Column
    private @Setter String idCardFrontImageUrl;

    @Column
    private @Setter String idCardBackImageUrl;

    @OneToOne(cascade = { CascadeType.PERSIST, CascadeType.REMOVE })
    private @Setter BalanceWallet balanceWallet;

    @OneToMany(mappedBy = "landlord")
    private @Setter List<Homestay> homestays;

    @OneToMany(mappedBy = "landlord")
    private @Setter List<BlocHomestay> blocHomestays;

    @OneToOne(mappedBy = "landlordProperty")
    private @Setter SwmUser user;

    @OneToMany(mappedBy = "landlord")
    private @Setter List<PromotionCampaign> campaigns;
}
