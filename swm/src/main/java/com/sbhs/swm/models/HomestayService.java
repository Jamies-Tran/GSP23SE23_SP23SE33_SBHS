package com.sbhs.swm.models;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class HomestayService extends BaseModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(columnDefinition = "nvarchar(500)")
    private @Setter String name;

    @Column
    private @Setter Long price;

    @Column
    private @Setter String status;

    @ManyToOne
    private @Setter BlocHomestay bloc;

    @ManyToOne
    private @Setter Homestay homestay;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "booking_service", joinColumns = @JoinColumn(name = "service_id", referencedColumnName = "id"), inverseJoinColumns = @JoinColumn(name = "booking_id", referencedColumnName = "id"))
    private @Setter List<Booking> bookings;
}
