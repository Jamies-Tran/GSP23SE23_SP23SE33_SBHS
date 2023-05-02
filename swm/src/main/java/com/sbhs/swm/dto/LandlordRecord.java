package com.sbhs.swm.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class LandlordRecord {
    private String imageUrl;
    private String name;
    private Long commission = 0L;
    private Long activatingHomestays = 0L;
    private Long activatingBlocHomestays = 0L;
    private String createdDate;
}
