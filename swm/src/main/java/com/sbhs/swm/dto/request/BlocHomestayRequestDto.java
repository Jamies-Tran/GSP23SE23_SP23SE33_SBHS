package com.sbhs.swm.dto.request;

import java.util.List;

import com.sbhs.swm.dto.HomestayInBlocDto;
import com.sbhs.swm.dto.HomestayServiceDto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class BlocHomestayRequestDto {
    private Long id;
    private String name;
    private String address;
    private String businessLicense;
    private String status;
    private List<HomestayServiceDto> homestayServices;
    private List<HomestayInBlocDto> homestays;

}
