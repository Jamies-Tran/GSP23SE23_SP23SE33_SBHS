package com.sbhs.swm.services;

import java.util.List;

import com.sbhs.swm.models.Promotion;

public interface IPromotionService {
    Promotion createPromotion(Promotion promotion, String promotionType, String homestayName,
            String homestayLocation);

    Promotion findPromotionByCode(String code);

    List<Promotion> getPromotionList();

}
