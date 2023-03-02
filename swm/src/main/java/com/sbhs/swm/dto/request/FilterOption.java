package com.sbhs.swm.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class FilterOption {
    private String homestayType;
    private Integer totalRoom;
    private Boolean rating;
    private FilterByBookingDate filterByBookingDate;
    private FilterByAddress filterByAddress;
}
