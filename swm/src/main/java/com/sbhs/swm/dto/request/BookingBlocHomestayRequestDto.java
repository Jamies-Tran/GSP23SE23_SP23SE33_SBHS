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
public class BookingBlocHomestayRequestDto {
    private String blocName;
    private List<BookingBlocRequestDto> bookingRequestList;
    private List<String> homestayServiceNameList;
    private String paymentMethod;
    private Long totalBookingPrice;
    private Long totalServicePrice;
}
