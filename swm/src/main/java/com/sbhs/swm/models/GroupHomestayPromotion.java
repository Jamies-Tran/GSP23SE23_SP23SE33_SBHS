package com.sbhs.swm.models;

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
public class GroupHomestayPromotion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(mappedBy = "groupHomestayPromotion")
    private @Setter Promotion promotion;

    @OneToOne(mappedBy = "availableGroupHomestayPromotion")
    private @Setter Landlord groupHomestayOwner;
}
