package com.sbhs.swm.implement;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Service;

import com.sbhs.swm.handlers.exceptions.InvalidDiscountAmountException;
import com.sbhs.swm.handlers.exceptions.InvalidPromotionDateException;
import com.sbhs.swm.handlers.exceptions.PromotionNotFoundException;
import com.sbhs.swm.handlers.exceptions.UsernameNotFoundException;
import com.sbhs.swm.models.GroupHomestayPromotion;
import com.sbhs.swm.models.Promotion;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.models.status.PromotionStatus;
import com.sbhs.swm.models.type.DiscountType;
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
    public Promotion findPromotionByCode(String code) {
        Promotion promotion = promotionRepo.findPromotionByCode(code)
                .orElseThrow(() -> new PromotionNotFoundException());
        return promotion;
    }

    @Override
    public List<Promotion> getPromotionList() {
        SwmUser user = userService.authenticatedUser();

        return promotionRepo.findPromotionByOwner(user.getUsername());
    }

    @Override
    public Promotion createPromotion(Promotion promotion, String promotionType,
            @Nullable String homestayName,
            @Nullable String location) {
        if (promotion.getDiscountType().equalsIgnoreCase(DiscountType.PERCENTAGE.name())
                && promotion.getDiscountAmount() > 100) {
            throw new InvalidDiscountAmountException();
        }
        if (dateFormatUtil.formatGivenDate(promotion.getEndDate())
                .after(dateFormatUtil.formatGivenDate(promotion.getStartDate()))
                && dateFormatUtil.formatDateTimeNow()
                        .before(dateFormatUtil.formatGivenDate(promotion.getEndDate()))) {
            if (dateFormatUtil.formatDateTimeNow()
                    .before(dateFormatUtil.formatGivenDate(promotion.getStartDate()))) {
                promotion.setStatus(PromotionStatus.NOT_ACTIVATE.name());
            } else {
                promotion.setStatus(PromotionStatus.ACTIVATED.name());
            }
        } else {
            throw new InvalidPromotionDateException();
        }
        SwmUser user = userService.authenticatedUser();
        switch (promotionType) {
            case "GROUP":
                if (user.getLandlordProperty() == null) {
                    throw new UsernameNotFoundException(user.getUsername());
                }
                GroupHomestayPromotion groupHomestayPromotion = new GroupHomestayPromotion();
                groupHomestayPromotion.setGroupHomestayOwner(user.getLandlordProperty());
                groupHomestayPromotion.setPromotion(promotion);
                user.getLandlordProperty().setAvailableGroupHomestayPromotion(groupHomestayPromotion);
                promotion.setGroupHomestayPromotion(groupHomestayPromotion);
                break;
        }

        promotion.setLandlord(user.getLandlordProperty());
        user.getLandlordProperty().setPromotions(List.of(promotion));
        Promotion savedPromotion = promotionRepo.save(promotion);

        return savedPromotion;
    }
}
