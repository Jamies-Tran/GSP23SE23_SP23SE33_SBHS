package com.sbhs.swm.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class PaymentHistoryResponseDto extends BaseResponseDto {
    private Long id;
    private Long amount;
    private String createdDate;
    private String paymentMethod;
}
