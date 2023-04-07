package com.sbhs.swm.dto;

import com.sbhs.swm.dto.response.BookingResponseDto;
import com.sbhs.swm.dto.response.PassengerResponseDto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class BookingShareCodeDto {
    private Long id;
    private String status;
    private BookingResponseDto booking;
    private PassengerResponseDto passenger;
}
