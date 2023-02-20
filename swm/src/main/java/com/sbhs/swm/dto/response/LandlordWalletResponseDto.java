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
public class LandlordWalletResponseDto extends BaseResponseDto {
    private Long id;
    private List<LandlordCommissionResponseDto> landlordCommissions;
    private List<PaymentHistoryResponseDto> paymentHistories;
}
