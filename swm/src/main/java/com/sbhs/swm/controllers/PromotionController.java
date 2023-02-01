package com.sbhs.swm.controllers;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.sbhs.swm.dto.PercentagePromotionDto;
import com.sbhs.swm.models.PercentagePromotion;
import com.sbhs.swm.models.Promotion;
import com.sbhs.swm.services.IPromotionService;

@RestController
@RequestMapping("/api/promotion")
public class PromotionController {

    @Autowired
    private IPromotionService promotionService;

    @Autowired
    private ModelMapper modelMapper;

    @PreAuthorize("hasAuthority('promotion:create')")
    @PostMapping("/percentage-creation")
    public ResponseEntity<?> createPercentagePromotion(@RequestBody PercentagePromotionDto promotionDto,
            @RequestParam String creator) {
        PercentagePromotion promotion = modelMapper.map(promotionDto, PercentagePromotion.class);
        Promotion savedPromotion = promotionService.createPercentagePromotion(promotion, creator);
        PercentagePromotionDto responsePromtion = modelMapper.map(savedPromotion, PercentagePromotionDto.class);

        return new ResponseEntity<PercentagePromotionDto>(responsePromtion, HttpStatus.OK);
    }
}
