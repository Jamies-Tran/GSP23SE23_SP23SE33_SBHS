package com.sbhs.swm.controllers;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.support.PagedListHolder;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sbhs.swm.dto.PromotionDto;
import com.sbhs.swm.dto.paging.PromotionListPagingDto;
import com.sbhs.swm.models.Promotion;
import com.sbhs.swm.services.IPromotionService;

@RestController
@RequestMapping("/api/promotion")
public class PromotionController {

    @Autowired
    private IPromotionService promotionService;

    @Autowired
    private ModelMapper modelMapper;

    @GetMapping
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> getPromotionByCode(String code) {
        Promotion promotion = promotionService.getPromotionByCode(code);
        PromotionDto responsePromotion = modelMapper.map(promotion, PromotionDto.class);

        return new ResponseEntity<PromotionDto>(responsePromotion, HttpStatus.OK);
    }

    @GetMapping("/list")
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> getPromotionListByStatusAndHomestayType(String status, String homestayType, int page,
            int size,
            Boolean isNextPage,
            Boolean isPreviousPage) {
        PagedListHolder<Promotion> promotionPageList = promotionService.getPromotionListByStatusAndHomestayType(status,
                homestayType, page, size,
                isNextPage, isPreviousPage);
        List<PromotionDto> responsePromotionList = promotionPageList.getPageList().stream()
                .map(p -> modelMapper.map(p, PromotionDto.class)).collect(Collectors.toList());
        PromotionListPagingDto promotionListPagingDto = new PromotionListPagingDto();
        promotionListPagingDto.setPromotions(responsePromotionList);
        promotionListPagingDto.setPageNumber(promotionPageList.getPage());

        return new ResponseEntity<PromotionListPagingDto>(promotionListPagingDto, HttpStatus.OK);
    }

    @PutMapping("/apply")
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> applyPromotions(@RequestBody List<String> promotionCodes, Long bookingId) {
        promotionService.applyPromotion(promotionCodes, bookingId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

}
