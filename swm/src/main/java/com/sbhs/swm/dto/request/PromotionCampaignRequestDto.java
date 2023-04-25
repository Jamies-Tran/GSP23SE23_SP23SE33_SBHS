package com.sbhs.swm.dto.request;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class PromotionCampaignRequestDto {
    private String name;
    private String description;
    private String thumbnailUrl;
    private String startDate;
    private String endDate;
    private Integer discountPercent;
    private List<String> homestayNameList;
    private List<String> blocNameList;
}
