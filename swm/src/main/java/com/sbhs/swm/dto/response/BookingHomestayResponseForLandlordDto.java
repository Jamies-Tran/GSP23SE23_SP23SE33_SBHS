package com.sbhs.swm.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class BookingHomestayResponseForLandlordDto {
    private BookingResponseForLandlordDto booking;
    private HomestayResponseDto homestay;
    private Long totalBookingPrice;
    private Long totalReservation;
    private String paymentMethod;

}
