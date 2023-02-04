package com.sbhs.swm.models;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class Passenger {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(cascade = { CascadeType.PERSIST, CascadeType.REMOVE })
    private @Setter BalanceWallet passengerWallet;

    @OneToMany(mappedBy = "passenger")
    private @Setter List<Booking> bookings;

    @OneToMany(mappedBy = "passenger")
    private @Setter List<Promotion> promotionWallet;

    @OneToOne(mappedBy = "passengerProperty", cascade = { CascadeType.REFRESH, CascadeType.MERGE })
    private @Setter SwmUser user;

}
