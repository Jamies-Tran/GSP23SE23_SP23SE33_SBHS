package com.sbhs.swm.services;

import com.sbhs.swm.models.PercentagePromotion;
import com.sbhs.swm.models.Promotion;

public interface IPromotionService {
    Promotion createPercentagePromotion(PercentagePromotion promotion, String creator);

    Promotion findPromotionByCode(String code);
}
