package com.sbhs.swm.models;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
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
public class Booking extends BaseModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true)
    private @Setter String code;

    @Column
    private @Setter String bookingFrom;

    @Column
    private @Setter String bookingTo;

    @Column
    private @Setter Long totalBookingPrice = 0L;

    @Column
    private @Setter Long totalBookingDeposit = 0L;

    @Column
    private @Setter String status;

    @ManyToOne
    private @Setter Passenger passenger;

    @Column
    private @Setter String homestayType;

    @ManyToOne
    private @Setter BlocHomestay bloc;

    @OneToMany(mappedBy = "booking", cascade = { CascadeType.REMOVE })
    private @Setter List<BookingHomestay> bookingHomestays;

    @OneToMany(mappedBy = "booking", cascade = { CascadeType.ALL })
    private @Setter List<BookingHomestayService> bookingHomestayServices;

    @OneToMany(mappedBy = "booking", cascade = { CascadeType.REMOVE })
    private @Setter List<BookingDeposit> bookingDeposits;

    @OneToOne(cascade = { CascadeType.PERSIST, CascadeType.REMOVE })
    @JoinColumn(name = "invite_id", referencedColumnName = "id")
    private @Setter BookingInviteCode inviteCode;

}
