package com.sbhs.swm.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class PercentagePromotionDto {
    private Long id;
    private String code;
    private String createdDate;
    private String expiredDate;
    private Double discountPercentage;
}
