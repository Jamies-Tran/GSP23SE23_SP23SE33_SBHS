package com.sbhs.swm.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.sbhs.swm.models.Deposit;

public interface DepositRepo extends JpaRepository<Deposit, Long> {

    @Query(value = "select sum(d.unpaidAmount) from BookingDeposit d where d.booking.passenger.user.username = :username")
    Long getTotalUnpaidAmountFromUser(@Param("username") String username);
}
