package com.sbhs.swm.services;

import org.springframework.beans.support.PagedListHolder;

import com.sbhs.swm.dto.request.PromotionCampaignRequestDto;
import com.sbhs.swm.models.PromotionCampaign;

public interface IPromotionCampaignService {
    PromotionCampaign createPromotionCampaign(PromotionCampaignRequestDto promotionCampaign);

    PagedListHolder<PromotionCampaign> getPromotionCampaignListByStatus(String status, int page, int size,
            boolean isNextPage, boolean isPreviousPage);

    PromotionCampaign getPromotionCampaignById(Long id);

    void updatePromotionCampaignStatus();

}
