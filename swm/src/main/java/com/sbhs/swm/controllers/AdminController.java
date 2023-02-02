package com.sbhs.swm.controllers;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.sbhs.swm.dto.SwmUserDto;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.services.IAdminService;

@RestController
@RequestMapping("/api/admin")
public class AdminController {

    @Autowired
    private ModelMapper modelMapper;

    @Autowired
    private IAdminService adminService;

    @PostMapping("/creation")
    @PreAuthorize("hasAuthority('admin:create')")
    public ResponseEntity<?> createAdmin(@RequestBody SwmUserDto userDto) {
        SwmUser user = modelMapper.map(userDto, SwmUser.class);
        SwmUser savedUser = adminService.createAdminAccount(user);
        SwmUserDto responseUser = modelMapper.map(savedUser, SwmUserDto.class);

        return new ResponseEntity<SwmUserDto>(responseUser, HttpStatus.CREATED);
    }

    @PostMapping("/first")
    public ResponseEntity<?> createFirstAdmin() {
        SwmUser admin = adminService.createFirstAdminAccount();
        SwmUserDto responseAdmin = modelMapper.map(admin, SwmUserDto.class);

        return new ResponseEntity<SwmUserDto>(responseAdmin, HttpStatus.CREATED);
    }

    @GetMapping("/landlord-list")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> getLandlordListFilterByStatus(@RequestParam String status, @RequestParam int page,
            @RequestParam int size) {
        List<SwmUser> landlordList = adminService.findLandlordListFilterByStatus(status, page, size);
        List<SwmUserDto> responseLandlordList = landlordList.stream().map(l -> modelMapper.map(l, SwmUserDto.class))
                .collect(Collectors.toList());

        return new ResponseEntity<List<SwmUserDto>>(responseLandlordList, HttpStatus.OK);
    }

    @PutMapping("/landlord-activate")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> activateLandlordAccount(@RequestParam String username) {
        SwmUser activatedLandlord = adminService.activateLandlordAccount(username);
        SwmUserDto responseLandlord = modelMapper.map(activatedLandlord, SwmUserDto.class);

        return new ResponseEntity<SwmUserDto>(responseLandlord, HttpStatus.OK);
    }
}
