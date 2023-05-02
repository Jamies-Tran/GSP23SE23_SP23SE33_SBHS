package com.sbhs.swm.services;

import com.sbhs.swm.dto.AdminDashboard;
import com.sbhs.swm.dto.LandlordDashBoard;

public interface IDashBoardService {
    LandlordDashBoard landlordDashBoard();

    AdminDashboard adminDashboard();
}
