package com.sbhs.swm.models;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MapsId;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class BookingDeposit {
    @EmbeddedId
    private BookingDepositId bookingDepositId = new BookingDepositId();

    @MapsId("bookingId")
    @ManyToOne
    @JoinColumn
    private Booking booking;

    @MapsId("depositId")
    @ManyToOne
    @JoinColumn
    private Deposit deposit;

    @Column
    private String depositForHomestay;

    @Column
    private @Setter Long paidAmount;

    @Column
    private @Setter Long unpaidAmount;
}
