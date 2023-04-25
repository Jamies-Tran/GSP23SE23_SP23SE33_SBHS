package com.sbhs.swm.implement;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.support.PagedListHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sbhs.swm.dto.request.PromotionCampaignRequestDto;
import com.sbhs.swm.handlers.exceptions.NotFoundException;
import com.sbhs.swm.models.BlocHomestay;
import com.sbhs.swm.models.Homestay;
import com.sbhs.swm.models.PromotionCampaign;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.models.status.PromotionCampaignStatus;
import com.sbhs.swm.repositories.PromotionCampaignRepo;
import com.sbhs.swm.services.IHomestayService;
import com.sbhs.swm.services.IPromotionCampaignService;
import com.sbhs.swm.services.IUserService;
import com.sbhs.swm.util.DateTimeUtil;

@Service
public class PromotionCampaignService implements IPromotionCampaignService {

    @Autowired
    private PromotionCampaignRepo promotionCampaignRepo;

    @Autowired
    private IHomestayService homestaySerivce;

    @Autowired
    private IUserService userService;

    @Autowired
    private DateTimeUtil dateTimeUtil;

    @Override
    public PromotionCampaign createPromotionCampaign(PromotionCampaignRequestDto promotionCampaignRequest) {
        SwmUser user = userService.authenticatedUser();
        PromotionCampaign promotionCampaign = new PromotionCampaign();
        promotionCampaign.setName(promotionCampaignRequest.getName());
        promotionCampaign.setDescription(promotionCampaignRequest.getDescription());
        promotionCampaign.setThumbnailUrl(promotionCampaignRequest.getThumbnailUrl());
        promotionCampaign.setDiscountPercent(promotionCampaignRequest.getDiscountPercent());
        promotionCampaign.setStartDate(promotionCampaignRequest.getStartDate());
        promotionCampaign.setEndDate(promotionCampaignRequest.getEndDate());
        if (dateTimeUtil.formatGivenDate(promotionCampaignRequest.getStartDate())
                .compareTo(dateTimeUtil.formatDateTimeNow()) >= 0) {
            promotionCampaign.setStatus(PromotionCampaignStatus.PROGRESSING.name());
        } else if (dateTimeUtil.formatGivenDate(promotionCampaignRequest.getStartDate())
                .compareTo(dateTimeUtil.formatDateTimeNow()) == -1) {
            promotionCampaign.setStatus(PromotionCampaignStatus.PENDING.name());
        }

        if (promotionCampaignRequest.getHomestayNameList() != null
                || !promotionCampaignRequest.getHomestayNameList().isEmpty()) {
            List<Homestay> homestayList = promotionCampaignRequest.getHomestayNameList().stream()
                    .map(h -> homestaySerivce.findHomestayByName(h)).collect(Collectors.toList());
            promotionCampaign.setHomestays(homestayList);
            homestayList.forEach(h -> h.setCampaigns(List.of(promotionCampaign)));
        }
        if (promotionCampaignRequest.getBlocNameList() != null
                || !promotionCampaignRequest.getBlocNameList().isEmpty()) {
            List<BlocHomestay> blocList = promotionCampaignRequest.getBlocNameList().stream()
                    .map(b -> homestaySerivce.findBlocHomestayByName(b)).collect(Collectors.toList());
            promotionCampaign.setBlocs(blocList);
            blocList.forEach(b -> b.setCampaigns(List.of(promotionCampaign)));
        }
        promotionCampaign.setCreatedBy(user.getUsername());
        promotionCampaign.setCreatedDate(dateTimeUtil.formatDateTimeNowToString());
        PromotionCampaign savedPromotionCampaign = promotionCampaignRepo.save(promotionCampaign);
        return savedPromotionCampaign;
    }

    @Override
    public PagedListHolder<PromotionCampaign> getPromotionCampaignListByStatus(String status, int page, int size,
            boolean isNextPage, boolean isPreviousPage) {
        List<PromotionCampaign> getCampaignList = promotionCampaignRepo
                .findPromotionCampaignByStatus(status.toUpperCase());
        PagedListHolder<PromotionCampaign> pagedListHolder = new PagedListHolder<>(getCampaignList);
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
    public PromotionCampaign getPromotionCampaignById(Long id) {
        PromotionCampaign promotionCampaign = promotionCampaignRepo.findById(id)
                .orElseThrow(() -> new NotFoundException("Can't find campaign"));

        return promotionCampaign;
    }

    @Override
    @Transactional
    public void updatePromotionCampaignStatus() {
        List<PromotionCampaign> promotionCampaigns = promotionCampaignRepo.findAll();
        for (PromotionCampaign p : promotionCampaigns) {
            if (dateTimeUtil.formatGivenDate(p.getStartDate()).equals(dateTimeUtil.formatDateTimeNow())) {
                p.setStatus(PromotionCampaignStatus.PROGRESSING.name());
            } else if (dateTimeUtil.formatGivenDate(p.getEndDate()).equals(dateTimeUtil.formatDateTimeNow())) {
                p.setStatus(PromotionCampaignStatus.FINISHED.name());
            }
        }
    }

}
