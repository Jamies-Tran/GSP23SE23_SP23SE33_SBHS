package com.sbhs.swm.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.sbhs.swm.models.Promotion;

public interface PromotionRepo extends JpaRepository<Promotion, Long> {
    @Query(value = "select p from Promotion p where p.code = :code")
    Optional<Promotion> findPromotionByCode(@Param("code") String code);

    @Query(value = "select p from Promotion p where p.landlord.user.username = :username or p.admin.user.username = :username or p.passenger.user.username = :username")
    List<Promotion> findPromotionByOwner(@Param("username") String username);
}
