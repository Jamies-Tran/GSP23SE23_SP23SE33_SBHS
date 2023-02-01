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
public class Admin {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToMany(mappedBy = "admin")
    private @Setter List<PercentagePromotion> percentagePromotions;

    @OneToMany(mappedBy = "admin")
    private @Setter List<PriceValuePromotion> priceValuePromotions;

    @OneToOne(mappedBy = "adminProperty")
    private @Setter SwmUser user;
}
