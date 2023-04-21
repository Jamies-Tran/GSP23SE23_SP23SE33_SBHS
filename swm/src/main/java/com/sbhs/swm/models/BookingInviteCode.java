package com.sbhs.swm.models;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToMany;

import javax.persistence.OneToOne;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class BookingInviteCode extends BaseModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true)
    private @Setter String inviteCode;

    @Column
    private @Setter String status;

    @OneToOne(mappedBy = "inviteCode")
    private @Setter Booking booking;

    @ManyToMany(mappedBy = "inviteCodes")
    private @Setter List<Passenger> passengers;
}
