package com.sbhs.swm.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class SwmUserRequestDto {
    private Long id;
    private String username;
    private String password;
    private String email;
    private String gender;
    private String phone;
    private String idCardNumber;
    private String dob;
    private String address;
    private String avatarUrl;
}
