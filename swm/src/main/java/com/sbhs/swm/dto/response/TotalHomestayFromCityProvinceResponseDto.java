package com.sbhs.swm.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class TotalHomestayFromCityProvinceResponseDto implements Comparable<TotalHomestayFromCityProvinceResponseDto> {
    private String cityProvince;
    private Integer total;

    @Override
    public int compareTo(TotalHomestayFromCityProvinceResponseDto o) {
        if (o.getTotal() < this.getTotal()) {
            return -1;
        } else if (o.getTotal() > this.getTotal()) {
            return 1;
        } else {
            return 0;
        }
    }
}
