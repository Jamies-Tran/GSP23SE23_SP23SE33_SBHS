package com.sbhs.swm.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class HomestayDto {
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
}
