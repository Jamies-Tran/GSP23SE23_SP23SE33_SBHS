package com.sbhs.swm.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class LandlordWalletDto {
    private Long id;
    private List<LandlordCommissionDto> landlordCommissions;
    private List<PaymentHistoryDto> paymentHistories;
}
