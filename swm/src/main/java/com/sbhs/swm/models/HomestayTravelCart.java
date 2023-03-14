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
public class HomestayTravelCart {
    @EmbeddedId
    private HomestayTravelCartId homestayTravelCardId = new HomestayTravelCartId();

    @MapsId("homestayId")
    @ManyToOne
    @JoinColumn
    private Homestay homestay;

    @MapsId("travelCartId")
    @ManyToOne
    @JoinColumn
    private TravelCart travelCart;

    @Column
    private String bookingFrom;

    @Column
    private String bookingTo;

    @Column
    private Long price;

    @Column
    private Long deposit;

}
