package com.sbhs.swm.implement;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sbhs.swm.handlers.exceptions.InvalidPromotionDateException;
import com.sbhs.swm.handlers.exceptions.InvalidPromotionDiscountException;
import com.sbhs.swm.handlers.exceptions.PromotionNotFoundException;
import com.sbhs.swm.models.PercentagePromotion;
import com.sbhs.swm.models.PriceValuePromotion;
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
        if (promotion.getPercentageDiscount() == 0) {
            throw new InvalidPromotionDiscountException();
        }
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
                promotion.setStatus(PromotionStatus.ACTIVATED.name());
            } else {
                promotion.setStatus(PromotionStatus.NOT_ACTIVATE.name());
            }
        } else {
            throw new InvalidPromotionDateException();
        }

        Promotion savedPromotion = promotionRepo.save(promotion);

        return savedPromotion;
    }

    @Override
    public Promotion findPromotionByCode(String code) {
        Promotion promotion = promotionRepo.findPromotionByCode(code)
                .orElseThrow(() -> new PromotionNotFoundException());
        return promotion;
    }

    @Override
    public Promotion createPriceValuePromotion(PriceValuePromotion promotion, String creator) {
        if (promotion.getPriceDiscount() == 0) {
            throw new InvalidPromotionDiscountException();
        }
        SwmUser user = userService.authenticatedUser();
        switch (creator) {
            case "LANDLORD":
                promotion.setLandlord(user.getLandlordProperty());
                user.getLandlordProperty().setPriceValuePromotions(List.of(promotion));
                break;
            case "ADMIN":
                promotion.setAdmin(user.getAdminProperty());
                user.getAdminProperty().setPriceValuePromotions(List.of(promotion));
                break;
        }
        if (dateFormatUtil.formatDateTimeNow().before(dateFormatUtil.formatGivenDate(promotion.getExpiredDate()))) {
            if (dateFormatUtil.formatDateTimeNow().equals(dateFormatUtil.formatGivenDate(promotion.getCreatedDate()))) {
                promotion.setStatus(PromotionStatus.ACTIVATED.name());
            } else {
                promotion.setStatus(PromotionStatus.NOT_ACTIVATE.name());
            }
        } else {
            throw new InvalidPromotionDateException();
        }

        Promotion savedPromotion = promotionRepo.save(promotion);

        return savedPromotion;
    }

    @Override
    public List<Promotion> getPromotionList() {
        SwmUser user = userService.authenticatedUser();

        return promotionRepo.findPromotionListByUsername(user.getUsername());
    }
}
