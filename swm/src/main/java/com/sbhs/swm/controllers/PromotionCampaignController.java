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
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sbhs.swm.dto.paging.CampaignListPagingDto;
import com.sbhs.swm.dto.request.PromotionCampaignRequestDto;
import com.sbhs.swm.dto.response.PromotionCampaignResponseDto;
import com.sbhs.swm.models.PromotionCampaign;
import com.sbhs.swm.services.IPromotionCampaignService;

@RestController
@RequestMapping("/api/campaign")
public class PromotionCampaignController {

        @Autowired
        private IPromotionCampaignService promotionCampaignService;

        @Autowired
        private ModelMapper modelMapper;

        @PostMapping
        @PreAuthorize("hasRole('ROLE_LANDLORD')")
        public ResponseEntity<?> createPromotionCampaign(@RequestBody PromotionCampaignRequestDto promotionRequest) {
                PromotionCampaign promotionCampaign = promotionCampaignService
                                .createPromotionCampaign(promotionRequest);
                PromotionCampaignResponseDto responseCampaign = modelMapper.map(promotionCampaign,
                                PromotionCampaignResponseDto.class);

                return new ResponseEntity<PromotionCampaignResponseDto>(responseCampaign, HttpStatus.OK);
        }

        @GetMapping("/list")
        @PreAuthorize("hasAnyRole('ROLE_LANDLORD', 'ROLE_PASSENGER')")
        public ResponseEntity<?> getPromotionCampaignListByStatus(String status, int page, int size, boolean isNextPage,
                        boolean isPreviousPage) {
                PagedListHolder<PromotionCampaign> promotionCampaignPagedList = promotionCampaignService
                                .getPromotionCampaignListByStatus(status, page, size, isNextPage, isPreviousPage);
                List<PromotionCampaignResponseDto> responseCampaignList = promotionCampaignPagedList.getPageList()
                                .stream()
                                .map(p -> modelMapper.map(p, PromotionCampaignResponseDto.class))
                                .collect(Collectors.toList());

                CampaignListPagingDto campaignListPagingDto = new CampaignListPagingDto();
                campaignListPagingDto.setCampaignList(responseCampaignList);
                campaignListPagingDto.setPageNumber(promotionCampaignPagedList.getPage());
                return new ResponseEntity<CampaignListPagingDto>(campaignListPagingDto, HttpStatus.OK);
        }

        @GetMapping
        @PreAuthorize("hasAnyRole('ROLE_LANDLORD', 'ROLE_PASSENGER')")
        public ResponseEntity<?> getPromotionCampaignById(Long campaignId) {
                PromotionCampaign promotionCampaign = promotionCampaignService.getPromotionCampaignById(campaignId);
                PromotionCampaignResponseDto responseCampaign = modelMapper.map(promotionCampaign,
                                PromotionCampaignResponseDto.class);

                return new ResponseEntity<PromotionCampaignResponseDto>(responseCampaign, HttpStatus.OK);
        }
}
