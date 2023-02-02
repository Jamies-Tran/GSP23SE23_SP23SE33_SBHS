package com.sbhs.swm.services;

import java.util.List;

import com.sbhs.swm.models.PercentagePromotion;
import com.sbhs.swm.models.PriceValuePromotion;
import com.sbhs.swm.models.Promotion;

public interface IPromotionService {
    Promotion createPercentagePromotion(PercentagePromotion promotion, String creator);

    Promotion createPriceValuePromotion(PriceValuePromotion promotion, String creator);

    Promotion findPromotionByCode(String code);

    List<Promotion> getPromotionList();

}
