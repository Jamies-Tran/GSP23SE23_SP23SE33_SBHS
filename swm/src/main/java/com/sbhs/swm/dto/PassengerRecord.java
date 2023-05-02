package com.sbhs.swm.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class PassengerRecord {
    private String imageUrl;
    private String name;
    private Long balance;
    private Long totalBooking;
}
