package com.sbhs.swm.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class LandlordHomestayRecord {
    private String imgUrl;
    private String name;
    private Long profit;
    private Long totalBooking;
}
