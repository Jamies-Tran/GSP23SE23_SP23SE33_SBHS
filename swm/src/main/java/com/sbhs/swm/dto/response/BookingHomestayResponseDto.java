package com.sbhs.swm.dto.response;

import com.sbhs.swm.dto.BookingDepositDto;
import com.sbhs.swm.dto.BookingHomestayIdDto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class BookingHomestayResponseDto {
    private BookingHomestayIdDto bookingHomestayId;
    private Long totalBookingPrice;
    private Long totalReservation;
    private String status;
    private HomestayResponseDto homestay;
    private BookingDepositDto bookingDeposit;
    
}
