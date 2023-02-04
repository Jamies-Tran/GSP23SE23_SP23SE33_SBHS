package com.sbhs.swm.controllers;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.sbhs.swm.dto.PromotionDto;
import com.sbhs.swm.models.Promotion;
import com.sbhs.swm.models.type.PromotionType;
import com.sbhs.swm.services.IPromotionService;

@RestController
@RequestMapping("/api/promotion")
public class PromotionController {

    @Autowired
    private IPromotionService promotionService;

    @Autowired
    private ModelMapper modelMapper;

    @PreAuthorize("hasAuthority('promotion:create')")
    @PostMapping("/new-group")
    public ResponseEntity<?> createGroupHomestayPromotion(@RequestBody PromotionDto promotionDto) {
        Promotion promotion = modelMapper.map(promotionDto, Promotion.class);
        Promotion savedPromotion = promotionService.createPromotion(promotion, PromotionType.GROUP.name(), null, null);
        PromotionDto responsePromtion = modelMapper.map(savedPromotion, PromotionDto.class);

        return new ResponseEntity<PromotionDto>(responsePromtion, HttpStatus.CREATED);
    }

    @GetMapping
    @PreAuthorize("hasAuthority('promotion:view')")
    public ResponseEntity<?> getPromotionByCode(@RequestParam String code) {
        Promotion promotion = promotionService.findPromotionByCode(code);
        PromotionDto responsePromotion = modelMapper.map(promotion, PromotionDto.class);

        return new ResponseEntity<PromotionDto>(responsePromotion, HttpStatus.OK);
    }

    @GetMapping("/list")
    @PreAuthorize("hasAuthority('promotion:view')")
    public ResponseEntity<?> getPromotionList() {
        List<Promotion> promotions = promotionService.getPromotionList();
        List<PromotionDto> responsePromotionList = promotions.stream().map(p -> modelMapper.map(p, PromotionDto.class))
                .collect(Collectors.toList());

        return new ResponseEntity<List<PromotionDto>>(responsePromotionList, HttpStatus.OK);
    }
}
