package com.sbhs.swm.dto;

import com.sbhs.swm.dto.response.BookingResponseDto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class BookingDepositDto {
    private BookingResponseDto booking;
    private Long paidAmount;
    private Long unpaidAmount;
    private String depositForHomestay;
    private String status;
}
