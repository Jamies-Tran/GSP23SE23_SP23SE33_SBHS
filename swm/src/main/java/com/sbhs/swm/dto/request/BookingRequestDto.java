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
public class BookingRequestDto {
    private String bookingFrom;
    private String bookingTo;
    private Long totalRoom;
    private Long totalPrice;
    private String homestayName;
    private String paymentType;
    private List<String> homestayServicesString;
    private Long depositPaidAmount;
    private String status;
}
