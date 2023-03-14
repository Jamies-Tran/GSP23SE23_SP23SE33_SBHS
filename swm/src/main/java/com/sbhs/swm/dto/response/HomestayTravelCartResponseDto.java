package com.sbhs.swm.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class HomestayTravelCartResponseDto {
    private HomestayResponseDto homestay;
    private String bookingFrom;
    private String bookingTo;
    private Long price;
    private Long deposit;
}
