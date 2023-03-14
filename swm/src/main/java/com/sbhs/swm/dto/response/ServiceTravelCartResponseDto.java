package com.sbhs.swm.dto.response;

import com.sbhs.swm.dto.HomestayServiceDto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class ServiceTravelCartResponseDto {
    private Long id;
    private HomestayServiceDto homestayService;
    private Long price;

}
