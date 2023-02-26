package com.sbhs.swm.dto.response;

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
public class HomestayResponseDto extends BaseResponseDto {
    private Long id;
    private String name;
    private Long price;
    private String address;
    private String cityProvince;
    private String businessLicense;
    private Integer availableRooms;
    private Double totalAverageRating;
    private Integer numberOfRating = 0;
    private String status;
    private List<HomestayImageDto> homestayImages;
    private List<HomestayFacilityDto> homestayFacilities;
    private List<HomestayServiceDto> homestayServices;
    private List<RatingResponseDto> ratings;
}
