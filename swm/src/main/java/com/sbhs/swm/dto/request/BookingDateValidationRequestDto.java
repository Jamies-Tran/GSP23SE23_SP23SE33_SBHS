package com.sbhs.swm.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class BookingDateValidationRequestDto {
    private String bookingStart;
    private String bookingEnd;
    private String homestayName;
    private Integer totalReservation;
}
