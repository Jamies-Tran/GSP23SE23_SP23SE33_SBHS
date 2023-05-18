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
    private Long totalReservation = 0L;
    private String status;
    private String paymentMethod;
    private HomestayResponseDto homestay;
    private BookingDepositDto bookingDeposit;
    private RatingResponseDto rating;
}
