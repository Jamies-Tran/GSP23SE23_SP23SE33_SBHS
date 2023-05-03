package com.sbhs.swm.dto.response;

import java.util.List;

import com.sbhs.swm.dto.HomestayServiceDto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class BlocHomestayResponseDto extends BaseResponseDto {
    private Long id;
    private String name;
    private String address;
    private String cityProvince;

    private String businessLicense;
    private String status;
    private Double totalAverageRating;
    private Integer numberOfRating = 0;
    private List<HomestayServiceDto> homestayServices;
    private List<HomestayResponseDto> homestays;
    private List<HomestayRuleResponseDto> homestayRules;
    private List<RatingResponseDto> ratings;
    private List<PromotionCampaignResponseDto> campaignListResponse;
    private Integer totalBookings;
    private Boolean isPendingBooking;
    private SwmUserResponseDto landlord;
}
