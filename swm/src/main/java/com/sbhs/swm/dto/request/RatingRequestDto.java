package com.sbhs.swm.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class RatingRequestDto {
    private Double securityPoint;
    private Double servicePoint;
    private Double locationPoint;
    private String comment;
    private Long homestayId;
    private Long bookingId;
}
