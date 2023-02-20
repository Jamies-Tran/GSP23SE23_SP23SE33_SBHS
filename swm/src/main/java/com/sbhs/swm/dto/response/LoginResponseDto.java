package com.sbhs.swm.dto.response;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class LoginResponseDto extends BaseResponseDto {
    private String username;
    private String email;
    private String token;
    private String expireDate;
    private List<String> roles;
}
