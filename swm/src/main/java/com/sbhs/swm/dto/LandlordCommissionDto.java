package com.sbhs.swm.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class LandlordCommissionDto {
    private Long id;
    private Long commission;
    private String commissionType;

}
