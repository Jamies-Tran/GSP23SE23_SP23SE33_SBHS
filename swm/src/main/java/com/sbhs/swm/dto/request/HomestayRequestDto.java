package com.sbhs.swm.dto.request;

import java.util.List;

import com.sbhs.swm.dto.HomestayFacilityDto;
import com.sbhs.swm.dto.HomestayImageDto;
import com.sbhs.swm.dto.HomestayServiceDto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class HomestayRequestDto {
    private Long id;
    private String name;
    private Long price;
    private String address;
    private String businessLicense;
    private Integer availableRooms;
    private String status;
    private List<HomestayImageDto> homestayImages;
    private List<HomestayFacilityDto> homestayFacilities;
    private List<HomestayServiceDto> homestayServices;
    private List<HomestayRuleRequestDto> homestayRules;
}
