package com.sbhs.swm.dto;

import java.util.List;

import com.sbhs.swm.dto.response.BlocHomestayResponseDto;
import com.sbhs.swm.dto.response.RatingResponseDto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class HomestayInBlocDto {
    private Long id;
    private String name;
    private Long price;
    private Double totalAverageRating;
    private Integer availableRooms;
    private Integer roomCapacity;
    private BlocHomestayResponseDto blocResponse;
    private List<HomestayImageDto> homestayImages;
    private List<HomestayFacilityDto> homestayFacilities;
    private List<RatingResponseDto> ratings;
}
