package com.sbhs.swm.dto.response;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class PassengerResponseDto extends BaseResponseDto {
    private Long id;
    private BalanceWalletResponseDto balanceWallet;
    private List<BookingResponseDto> bookings;
}
