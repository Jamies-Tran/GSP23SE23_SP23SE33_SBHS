package com.sbhs.swm.dto.response;

import com.sbhs.swm.dto.PassengerWalletDto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class BalanceWalletResponseDto extends BaseResponseDto {
    private Long id;
    private Long totalBalance;
    private Long actualBalance;
    private PassengerWalletDto passengerWallet;
    private LandlordWalletResponseDto landlordWallet;

}
