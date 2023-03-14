package com.sbhs.swm.models;

import java.util.List;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
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
public class TravelCart extends BaseModel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column
    private @Setter Long totalPrice = 0L;

    @Column
    private @Setter Long totalDeposit = 0L;

    @OneToOne
    private @Setter Booking booking;

    @OneToMany(mappedBy = "travelCart")
    private @Setter List<HomestayTravelCart> homestayTravelCarts;

    @OneToMany(mappedBy = "travelCart")
    private @Setter List<ServiceTravelCart> serviceTravelCarts;

    @ManyToOne
    private @Setter Passenger passenger;

}
