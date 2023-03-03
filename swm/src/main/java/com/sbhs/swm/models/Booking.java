package com.sbhs.swm.models;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinTable;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;

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

    @Column
    private @Setter String bookingFrom;

    @Column
    private @Setter String bookingTo;

    @Column
    private @Setter Long totalRoom;

    @Column
    private @Setter Long totalPrice;

    @Column
    private @Setter String status;

    @ManyToOne
    private @Setter Passenger passenger;

    @ManyToOne
    private @Setter Homestay homestay;

    @OneToOne(cascade = { CascadeType.PERSIST, CascadeType.REMOVE })
    private @Setter BookingDeposit deposit;

    @ManyToMany
    @JoinTable(name = "booking_service", joinColumns = @JoinColumn(name = "booking_id", referencedColumnName = "id"), inverseJoinColumns = @JoinColumn(name = "service_id", referencedColumnName = "id"))
    private @Setter List<HomestayService> homestayServices;
}
