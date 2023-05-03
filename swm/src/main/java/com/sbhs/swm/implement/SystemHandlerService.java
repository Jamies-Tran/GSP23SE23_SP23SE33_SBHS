package com.sbhs.swm.implement;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;

import com.sbhs.swm.services.IBookingService;
import com.sbhs.swm.services.IPromotionCampaignService;
import com.sbhs.swm.services.IPromotionService;

@EnableScheduling
@Configuration
public class SystemHandlerService {
    @Autowired
    private IPromotionCampaignService promotionCampaignService;

    @Autowired
    private IPromotionService promotionService;

    @Autowired
    private IBookingService bookingService;

    @Scheduled(fixedDelay = 60000)
    public void promotionCampaignHandler() {

        promotionCampaignService.updatePromotionCampaignStatus();
    }

    @Scheduled(fixedDelay = 60000)
    public void promotionHandler() {
        promotionService.updatePromotionStatus();
    }

    @Scheduled(fixedDelay = 300000)
    public void checkInHandler() {
        bookingService.bookingDateHandler();
    }

}
