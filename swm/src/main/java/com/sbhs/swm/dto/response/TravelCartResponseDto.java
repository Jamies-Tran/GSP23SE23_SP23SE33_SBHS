package com.sbhs.swm.dto.response;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class TravelCartResponseDto {
    private Long id;
    private Long totalPrice;
    private Long totalDeposit;
    private List<HomestayTravelCartResponseDto> homestayTravelCarts;
    private List<ServiceTravelCartResponseDto> serviceTravelCarts;
}
