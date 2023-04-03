package com.sbhs.swm.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class BookingHomestayUpdateRequestDto {
    private Long id;
    private Long totalBookingPrice;
    private Long totalReservation;
    private HomestayRequestDto homestay;
}
