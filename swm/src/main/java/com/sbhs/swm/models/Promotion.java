package com.sbhs.swm.models;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.MappedSuperclass;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@MappedSuperclass
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class Promotion {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true)
    private @Setter String code;

    @Column
    private @Setter String createdDate;

    @Column
    private @Setter String expiredDate;

    @Column
    private @Setter String status;

    @ManyToOne
    private @Setter Passenger passenger;

    @ManyToOne
    private @Setter Landlord landlord;

    @ManyToOne
    private @Setter Admin admin;

}
