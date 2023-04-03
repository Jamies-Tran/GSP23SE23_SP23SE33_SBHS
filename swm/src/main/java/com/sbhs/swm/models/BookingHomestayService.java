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
public class BookingHomestayService {
    @EmbeddedId
    private BookingHomestayServiceId bookingSaveServiceId = new BookingHomestayServiceId();

    @MapsId("bookingId")
    @ManyToOne
    @JoinColumn
    private Booking booking;

    @MapsId("homestayServiceId")
    @ManyToOne
    @JoinColumn
    private HomestayService homestayService;

    @Column(columnDefinition = "nvarchar(500)")
    private String homestayName;

    @Column
    private Long totalServicePrice;
}
