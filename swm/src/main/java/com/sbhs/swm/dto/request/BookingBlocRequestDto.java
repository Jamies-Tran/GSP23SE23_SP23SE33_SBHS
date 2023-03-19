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
    private String bookingFrom;
    private String bookingTo;
    private String paymentMethod;
    private Long totalReservation;
    private String homestayName;

}
