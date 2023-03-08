package com.sbhs.swm.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.sbhs.swm.models.LandlordCommission;

public interface LandlordCommissionRepo extends JpaRepository<LandlordCommission, Long> {

    @Query(value = "select sum(c.commission) from LandlordCommission c where c.landlordWallet.landlordBalanceWallet.landlord.user.username = :username")
    Long getLandlordTotalUnpaidAmountFromUser(@Param("username") String username);
}
