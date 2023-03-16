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
public class BookingServiceResponseDto {
    private Long totalServicePrice;
    private HomestayServiceDto homestayService;
}
