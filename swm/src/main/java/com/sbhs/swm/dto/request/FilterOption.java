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
    private FilterByRatingRange filterByRatingRange;
    private FilterByBookingDateRange filterByBookingDateRange;
    private FilterByAddress filterByAddress;
    private FilterByPriceRange filterByPriceRange;
    private FilterByFacility filterByFacility;
    private FilterByHomestayService filterByHomestayService;
}
