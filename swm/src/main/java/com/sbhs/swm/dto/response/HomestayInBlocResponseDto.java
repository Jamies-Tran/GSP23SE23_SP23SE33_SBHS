package com.sbhs.swm.dto.response;

import java.util.List;

import com.sbhs.swm.dto.HomestayFacilityDto;
import com.sbhs.swm.dto.HomestayImageDto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class HomestayInBlocResponseDto {
    private Long id;
    private String name;
    private Long price;
    private Double totalAverageRating;
    private Integer availableRooms;
    private Integer roomCapacity;

    private List<HomestayImageDto> homestayImages;
    private List<HomestayFacilityDto> homestayFacilities;
    // private List<RatingResponseDto> ratings;
}
