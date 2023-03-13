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
    private Long totalReservation;
    private Long totalPrice;
    private List<String> homestayNames;
    private String paymentType;
    private List<String> homestayServicesString;
    private Long depositPaidAmount;
    private String status;
}
