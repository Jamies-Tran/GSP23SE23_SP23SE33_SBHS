package com.sbhs.swm.controllers;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
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

import com.sbhs.swm.dto.HomestayDto;
import com.sbhs.swm.dto.paging.LandlordListPagingDto;
import com.sbhs.swm.dto.request.SwmUserRequestDto;
import com.sbhs.swm.dto.response.SwmUserResponseDto;
import com.sbhs.swm.models.Homestay;
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
    public ResponseEntity<?> createAdmin(@RequestBody SwmUserRequestDto userDto) {
        SwmUser user = modelMapper.map(userDto, SwmUser.class);
        SwmUser savedUser = adminService.createAdminAccount(user);
        SwmUserResponseDto responseUser = modelMapper.map(savedUser, SwmUserResponseDto.class);

        return new ResponseEntity<SwmUserResponseDto>(responseUser, HttpStatus.CREATED);
    }

    @PostMapping("/first")
    public ResponseEntity<?> createFirstAdmin() {
        SwmUser admin = adminService.createFirstAdminAccount();
        SwmUserResponseDto responseAdmin = modelMapper.map(admin, SwmUserResponseDto.class);

        return new ResponseEntity<SwmUserResponseDto>(responseAdmin, HttpStatus.CREATED);
    }

    @GetMapping("/landlord-list")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> getLandlordListFilterByStatus(@RequestParam String status, @RequestParam int page,
            @RequestParam int size, @RequestParam boolean isNextPage, @RequestParam boolean isPreviousPage) {
        Page<SwmUser> landlordList = adminService.findLandlordListFilterByStatus(status, page, size, isNextPage,
                isPreviousPage);
        List<SwmUserResponseDto> landlordDtoList = landlordList.stream()
                .map(l -> modelMapper.map(l, SwmUserResponseDto.class))
                .collect(Collectors.toList());
        LandlordListPagingDto landlordListPagingDto = new LandlordListPagingDto(landlordDtoList,
                landlordList.getNumber());

        return new ResponseEntity<LandlordListPagingDto>(landlordListPagingDto, HttpStatus.OK);
    }

    @PutMapping("/landlord-activate")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> activateLandlordAccount(@RequestParam String username) {
        SwmUser activatedLandlord = adminService.activateLandlordAccount(username);
        SwmUserResponseDto responseLandlord = modelMapper.map(activatedLandlord, SwmUserResponseDto.class);

        return new ResponseEntity<SwmUserResponseDto>(responseLandlord, HttpStatus.OK);
    }

    @PutMapping("/homestay-active")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> activeHomestay(@RequestParam String homestayName) {
        Homestay homestay = adminService.activateHomestay(homestayName);
        HomestayDto responseHomestay = modelMapper.map(homestay, HomestayDto.class);

        return new ResponseEntity<HomestayDto>(responseHomestay, HttpStatus.OK);
    }
}
