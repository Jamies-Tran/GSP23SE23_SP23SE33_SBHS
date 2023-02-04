package com.sbhs.swm.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class PromotionDto {
    private Long id;
    private String code;
    private String startDate;
    private String endDate;
    private String status;
    private Long discountAmount;
    private String discountType;
}
