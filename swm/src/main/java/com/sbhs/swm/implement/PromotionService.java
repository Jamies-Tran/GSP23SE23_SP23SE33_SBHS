package com.sbhs.swm.implement;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.support.PagedListHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sbhs.swm.handlers.exceptions.NotFoundException;
import com.sbhs.swm.models.Booking;
import com.sbhs.swm.models.Promotion;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.repositories.PromotionRepo;
import com.sbhs.swm.services.IBookingService;
import com.sbhs.swm.services.IPromotionService;
import com.sbhs.swm.services.IUserService;

@Service
public class PromotionService implements IPromotionService {

    @Autowired
    private PromotionRepo promotionRepo;

    @Autowired
    private IBookingService bookingService;

    @Autowired
    private IUserService userService;

    @Override
    public Promotion getPromotionByCode(String code) {
        Promotion promotion = promotionRepo.findPromotionByCode(code)
                .orElseThrow(() -> new NotFoundException("Promotion not found"));

        return promotion;
    }

    @Override
    public PagedListHolder<Promotion> getPromotionListByStatusAndHomestayType(String status, String homestayType,
            int page, int size, boolean isNextPage,
            boolean isPreviousPage) {
        SwmUser user = userService.authenticatedUser();
        List<Promotion> promotions = promotionRepo.findPromotionListByStatusAndHomestayType(status, homestayType);
        promotions = promotions.stream()
                .filter(p -> p.getPassenger().getUser().getUsername().equals(user.getUsername()))
                .collect(Collectors.toList());
        PagedListHolder<Promotion> pagedListHolder = new PagedListHolder<>(promotions);
        pagedListHolder.setPage(page);
        pagedListHolder.setPageSize(size);
        if (!pagedListHolder.isLastPage() && isNextPage == true && isPreviousPage == false) {
            pagedListHolder.nextPage();
        } else if (!pagedListHolder.isFirstPage() && isPreviousPage == true && isNextPage == false) {
            pagedListHolder.previousPage();
        }

        return pagedListHolder;
    }

    @Override
    @Transactional
    public void applyPromotion(List<String> promotionCodeList, Long bookingId) {
        Booking booking = bookingService.findBookingById(bookingId);
        if (promotionCodeList != null) {
            List<Promotion> promotions = promotionCodeList.stream().map(c -> this.getPromotionByCode(c))
                    .collect(Collectors.toList());
            for (Promotion p : promotions) {
                p.setBooking(booking);
            }
            booking.setPromotions(promotions);
        } else {
            booking.setPromotions(null);
        }

    }

    @Override
    public void removePromotion(Long bookingId) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'removePromotion'");
    }

}
