package com.sbhs.swm.models;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;

import com.sbhs.swm.models.status.PromotionStatus;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class Promotion extends BaseModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true)
    private @Setter String code;

    @Column
    private @Setter int discountAmount;

    @Column
    private @Setter String endDate;

    @Column
    private @Setter String status = PromotionStatus.NEW.name();

    @Column
    private @Setter String homestayType;

    @ManyToOne
    private @Setter Passenger passenger;

    @ManyToOne
    private @Setter Booking booking;

}
