package com.sbhs.swm.dto.request;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class TravelCartRequestDto {
    private String homestayName;
    private List<String> serviceNames;
    private String bookingFrom;
    private String bookingTo;

}
