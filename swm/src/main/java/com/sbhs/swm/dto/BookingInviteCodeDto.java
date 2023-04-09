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
public class BookingInviteCodeDto {
    private Long id;
    private String inviteCode;
    private String status;
    private BookingResponseDto booking;

}
