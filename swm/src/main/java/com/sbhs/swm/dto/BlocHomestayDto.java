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
public class BlocHomestayDto {
    private Long id;
    private String name;
    private String address;
    private String businessLicense;
    private String status;
    private List<HomestayServiceDto> homestayServices;
    private List<HomestayInBlocDto> homestays;

}
