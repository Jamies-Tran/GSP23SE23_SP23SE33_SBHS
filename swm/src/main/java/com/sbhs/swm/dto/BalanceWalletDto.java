package com.sbhs.swm.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class BalanceWalletDto {
    private Long id;
    private Long totalBalance;
    private PassengerWalletDto passengerWallet;
    private LandlordWalletDto landlordWallet;

}
