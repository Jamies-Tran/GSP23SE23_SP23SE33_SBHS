package com.sbhs.swm.models;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Embeddable
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class HomestayTravelCartId implements Serializable {
    @Column
    Long homestayId;

    @Column
    Long travelCartId;
}
