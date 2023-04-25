package com.sbhs.swm.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.sbhs.swm.models.PromotionCampaign;

public interface PromotionCampaignRepo extends JpaRepository<PromotionCampaign, Long> {

    @Query(value = "select p from PromotionCampaign p where p.status = :status")
    List<PromotionCampaign> findPromotionCampaignByStatus(String status);
}
