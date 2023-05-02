package com.sbhs.swm.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class AdminDashboard {
    private Long totalProfit = 0L;
    private Long totalLandlord = 0L;
    private Long totalPassenger = 0L;
    private List<LandlordRecord> landlordTable;
    private List<PassengerRecord> passengerTable;
}
