package com.sbhs.swm.dto.response;

import java.util.List;

import com.sbhs.swm.dto.PromotionDto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class BookingResponseDto {
    private Long id;
    private String code;
    private String bookingFrom;
    private String bookingTo;
    private Long totalBookingPrice;
    private Long totalBookingDeposit;
    private String status;
    private String homestayType;
    private BlocHomestayResponseDto blocResponse;
    private BookingInviteCodeResponseDto inviteCode;
    private List<BookingHomestayResponseDto> bookingHomestays;
    private List<BookingServiceResponseDto> bookingHomestayServices;
    private List<PromotionDto> promotions;
    private RatingResponseDto rating;
}
