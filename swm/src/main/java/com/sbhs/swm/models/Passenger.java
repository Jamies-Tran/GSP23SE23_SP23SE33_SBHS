package com.sbhs.swm.models;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
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
public class Passenger extends BaseModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToMany(mappedBy = "passenger")
    private @Setter List<Promotion> promotions;

    @OneToOne(cascade = { CascadeType.PERSIST, CascadeType.REMOVE })
    @JoinColumn(name = "passenger_wallet_id", referencedColumnName = "id")
    private @Setter BalanceWallet balanceWallet;

    @OneToMany(mappedBy = "passenger", fetch = FetchType.LAZY)
    private @Setter List<Rating> ratings;

    @OneToMany(mappedBy = "passenger")
    private @Setter List<Booking> bookings;

    @OneToOne(mappedBy = "passengerProperty", cascade = { CascadeType.REFRESH, CascadeType.MERGE })
    private @Setter SwmUser user;

    @ManyToMany
    @JoinTable(name = "invite_guest", joinColumns = @JoinColumn(name = "passener_id", referencedColumnName = "id"), inverseJoinColumns = @JoinColumn(name = "invite_id", referencedColumnName = "id"))
    private @Setter List<BookingInviteCode> inviteCodes;
}
