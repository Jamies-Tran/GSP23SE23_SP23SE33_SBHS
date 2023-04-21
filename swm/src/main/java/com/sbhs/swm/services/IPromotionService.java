package com.sbhs.swm.services;

import java.util.List;

import org.springframework.beans.support.PagedListHolder;

import com.sbhs.swm.models.Promotion;

public interface IPromotionService {
    Promotion getPromotionByCode(String code);

    PagedListHolder<Promotion> getPromotionListByStatusAndHomestayType(String status, String homestayType, int page,
            int size,
            boolean isNextPage,
            boolean isPreviousPage);

    void applyPromotion(List<String> promotionCodeList, Long bookingId);

    void removePromotion(Long bookingId);

}
