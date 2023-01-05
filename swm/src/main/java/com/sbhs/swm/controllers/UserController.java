package com.sbhs.swm.controllers;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sbhs.swm.dto.PassengerDto;
import com.sbhs.swm.dto.SwmUserDto;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.services.IUserService;

@RestController
@RequestMapping("/api/user")
public class UserController {

    @Autowired
    private IUserService userService;

    @Autowired
    private ModelMapper modelMapper;

    @PostMapping("/registeration")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> registerPassengerAccount(@RequestBody SwmUserDto userDto,
            @RequestBody PassengerDto passengerDto) {
        SwmUser user = modelMapper.map(userDto, SwmUser.class);
        return new ResponseEntity<>(HttpStatus.ACCEPTED);
    }
}
