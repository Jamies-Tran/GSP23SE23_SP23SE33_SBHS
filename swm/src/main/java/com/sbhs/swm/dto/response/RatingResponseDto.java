package com.sbhs.swm.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class RatingResponseDto extends BaseResponseDto {
    private Long id;
    private Double servicePoint;
    private Double locationPoint;
    private Double securityPoint;
    private double averagePoint;
    private String comment;
}
