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
public class PromotionCampaignResponseDto {
    private Long id;
    private String name;
    private String description;
    private String thumbnailUrl;
    private String startDate;
    private String endDate;
    private String status;
    private Integer discountPercent;
    private Long totalProfit;
    private Long totalBooking;
    private List<HomestayResponseDto> homestays;
    private List<BlocHomestayResponseDto> blocs;
}
