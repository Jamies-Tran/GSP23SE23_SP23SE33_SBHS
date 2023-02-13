package com.sbhs.swm.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class PaymentHistoryDto {
    private Long id;
    private Long amount;
    private String createdDate;
    private String paymentMethod;
}
