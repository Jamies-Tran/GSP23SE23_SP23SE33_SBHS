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
public class HomestayInBlocDto {
    private String name;
    private Long price;
    private Integer availableRooms;
    private List<HomestayImageDto> homestayImages;
}
