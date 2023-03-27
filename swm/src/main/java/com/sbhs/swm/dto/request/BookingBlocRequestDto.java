package com.sbhs.swm.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class BookingBlocRequestDto {

    private Long totalReservation;
    private Long totalBookingPrice;
    private String homestayName;

}
