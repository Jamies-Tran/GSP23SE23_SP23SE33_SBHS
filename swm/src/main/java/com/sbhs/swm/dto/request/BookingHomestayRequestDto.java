package com.sbhs.swm.dto.request;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class BookingHomestayRequestDto {
    private String paymentMethod;
    private Long totalReservation;
    private String homestayName;
    private Long totalBookingPrice;
    private Long totalServicePrice;
    private List<String> homestayServiceList;
}
