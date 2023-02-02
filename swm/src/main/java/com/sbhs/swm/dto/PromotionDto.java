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
    private String createdDate;
    private String expiredDate;
    private String status;
    private Double percentageDiscount;
    private Long priceDiscount;
    private String type;
}
