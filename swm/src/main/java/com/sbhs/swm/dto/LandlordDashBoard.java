package com.sbhs.swm.dto;

import java.util.ArrayList;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class LandlordDashBoard {
    private Long totalProfit = 0L;
    private Long totalPromotion = 0L;
    private Long totalCommission = 0L;
    private List<LandlordHomestayRecord> homestayTable = new ArrayList<>();
    private List<LandlordBlocRecord> blocTable = new ArrayList<>();

}
