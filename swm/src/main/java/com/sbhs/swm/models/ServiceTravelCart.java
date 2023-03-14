package com.sbhs.swm.models;

import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
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
public class ServiceTravelCart {
    @EmbeddedId
    private ServiceTravelCartId serviceTravelCartId = new ServiceTravelCartId();

    @MapsId("homestayServiceId")
    @ManyToOne
    private HomestayService homestayService;

    @MapsId("travelCartId")
    @ManyToOne
    private TravelCart travelCart;

    private Long price = 0L;
}
