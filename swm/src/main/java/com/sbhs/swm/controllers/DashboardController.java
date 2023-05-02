package com.sbhs.swm.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sbhs.swm.dto.AdminDashboard;
import com.sbhs.swm.dto.LandlordDashBoard;
import com.sbhs.swm.services.IDashBoardService;

@RestController
@RequestMapping("/api/dashboard")
public class DashboardController {

    @Autowired
    private IDashBoardService dashBoardService;

    @GetMapping("/landlord")
    @PreAuthorize("hasRole('ROLE_LANDLORD')")
    public ResponseEntity<?> getLandlordDashboard() {
        LandlordDashBoard landlordDashBoard = dashBoardService.landlordDashBoard();
        return new ResponseEntity<LandlordDashBoard>(landlordDashBoard, HttpStatus.OK);
    }

    @GetMapping("/admin")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> getAdminDashboard() {
        AdminDashboard adminDashboard = dashBoardService.adminDashboard();
        return new ResponseEntity<AdminDashboard>(adminDashboard, HttpStatus.OK);
    }
}
