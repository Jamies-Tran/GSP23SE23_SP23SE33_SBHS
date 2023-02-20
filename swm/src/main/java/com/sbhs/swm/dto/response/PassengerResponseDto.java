package com.sbhs.swm.dto.response;

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
    private BalanceWalletResponseDto passengerWallet;
}
