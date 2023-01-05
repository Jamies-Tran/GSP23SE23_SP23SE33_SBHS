package com.sbhs.swm.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@AllArgsConstructor
@Getter
@Setter
public class SwmUserDto {
    private Long Id;
    private String username;
    private String password;
    private String email;
    private int phone;
    private String address;
    private PassengerDto passengerProperty;
    private List<SwmRoleDto> roles;
}
