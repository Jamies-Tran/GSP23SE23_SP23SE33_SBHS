package com.sbhs.swm.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class LandlordResponseDto extends BaseResponseDto {
    private Long id;
    private String avatarUrl;
    private String idCardFrontImageUrl;
    private String idCardBackImageUrl;
    private String status;
    private BalanceWalletResponseDto balanceWallet;
}
