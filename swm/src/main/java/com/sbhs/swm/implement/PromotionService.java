package com.sbhs.swm.implement;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sbhs.swm.handlers.exceptions.InvalidPromotionException;
import com.sbhs.swm.models.PercentagePromotion;
import com.sbhs.swm.models.Promotion;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.models.status.PromotionStatus;
import com.sbhs.swm.repositories.PromotionRepo;
import com.sbhs.swm.services.IPromotionService;
import com.sbhs.swm.services.IUserService;
import com.sbhs.swm.util.DateFormatUtil;

@Service
public class PromotionService implements IPromotionService {

    @Autowired
    private PromotionRepo promotionRepo;

    @Autowired
    private IUserService userService;

    @Autowired
    private DateFormatUtil dateFormatUtil;

    @Override
    public Promotion createPercentagePromotion(PercentagePromotion promotion, String creator) {
        SwmUser user = userService.authenticatedUser();
        switch (creator) {
            case "LANDLORD":
                promotion.setLandlord(user.getLandlordProperty());
                user.getLandlordProperty().setPercentagePromotions(List.of(promotion));
                break;
            case "ADMIN":
                promotion.setAdmin(user.getAdminProperty());
                user.getAdminProperty().setPercentagePromotions(List.of(promotion));
                break;
        }
        if (dateFormatUtil.formatDateTimeNow().before(dateFormatUtil.formatGivenDate(promotion.getExpiredDate()))) {
            if (dateFormatUtil.formatDateTimeNow().equals(dateFormatUtil.formatGivenDate(promotion.getCreatedDate()))) {
                promotion.setStatus(PromotionStatus.ACTIVATED);
            } else {
                promotion.setStatus(PromotionStatus.NOT_ACTIVATE);
            }
        } else {
            throw new InvalidPromotionException();
        }

        Promotion savedPromotion = promotionRepo.save(promotion);

        return savedPromotion;
    }

    @Override
    public Promotion findPromotionByCode(String code) {
        // TODO Auto-generated method stub
        return null;
    }

}
