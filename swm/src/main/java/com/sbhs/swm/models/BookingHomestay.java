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
public class BookingHomestay {
    @EmbeddedId
    private BookingHomestayId bookingHomestayId = new BookingHomestayId();

    @MapsId("bookingId")
    @ManyToOne
    @JoinColumn
    private Booking booking;

    @MapsId("homestayId")
    @ManyToOne
    @JoinColumn
    private Homestay homestay;

    @Column
    private Long totalBookingPrice;

    @Column
    private Long totalReservation;

    @Column
    private @Setter String paymentMethod;

}
