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
public class BookingResponseForLandlordDto {
    private Long id;
    private String code;
    private String bookingFrom;
    private String bookingTo;
    private BlocHomestayResponseDto bloc;
    private List<BookingServiceResponseDto> bookingHomestayServices;
}
