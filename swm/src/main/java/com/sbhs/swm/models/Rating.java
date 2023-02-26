package com.sbhs.swm.models;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class Rating extends BaseModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column
    private @Setter double servicePoint = 0.0;

    @Column
    private @Setter double locationPoint = 0.0;

    @Column
    private @Setter double securityPoint = 0.0;

    @Column
    private @Setter double averagePoint = 0.0;

    @Column(columnDefinition = "nvarchar(500)")
    private @Setter String comment = "";

    @ManyToOne
    private @Setter Homestay homestay;

    @ManyToOne
    private @Setter BlocHomestay bloc;

    @ManyToOne
    private @Setter Passenger passenger;
}
