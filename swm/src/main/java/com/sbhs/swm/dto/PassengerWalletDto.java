package com.sbhs.swm.dto;

import java.util.List;

import com.sbhs.swm.dto.response.PaymentHistoryResponseDto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class PassengerWalletDto {
    private Long id;
    private List<BookingDepositDto> deposits;
    private List<PaymentHistoryResponseDto> paymentHistories;

}
