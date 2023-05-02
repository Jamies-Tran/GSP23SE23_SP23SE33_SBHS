package com.sbhs.swm.dto;

import java.util.List;

import com.sbhs.swm.dto.response.BaseResponseDto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class DepositDto extends BaseResponseDto {
    private Long id;
    private List<BookingDepositDto> bookingDeposits;
}
