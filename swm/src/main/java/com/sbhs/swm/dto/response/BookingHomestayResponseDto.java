package com.sbhs.swm.dto.response;

import com.sbhs.swm.dto.BookingDepositDto;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class BookingHomestayResponseDto {
    private String bookingFrom;
    private String bookingTo;
    private Long price;
    private String paymentMethod;
    private String homestayType;
    private Long totalReservation;
    private HomestayResponseDto homestay;
    private BookingDepositDto bookingDeposit;
}
