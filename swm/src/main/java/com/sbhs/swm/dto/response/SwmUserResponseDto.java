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
public class SwmUserResponseDto extends BaseResponseDto {
    private Long id;
    private String username;
    private String email;
    private String gender;
    private String phone;
    private String idCardNumber;
    private String dob;
    private String address;
    private String avatarUrl;
    private PassengerResponseDto passengerProperty;
    private LandlordResponseDto landlordProperty;
    private AdminResponseDto adminProperty;
    private List<Long> roleIds;
}
