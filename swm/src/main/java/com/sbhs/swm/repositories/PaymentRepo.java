package com.sbhs.swm.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.sbhs.swm.models.PaymentHistory;

public interface PaymentRepo extends JpaRepository<PaymentHistory, Long> {

    @Query(value = "select p from PaymentHistory p where p.passengerWallet.passengerBalanceWallet.passenger.user.username = :username")
    List<PaymentHistory> findPaymentHistoriesByPassenger(@Param("username") String username);

    @Query(value = "select p from PaymentHistory p where p.landlordWallet.landlordBalanceWallet.landlord.user.username = :username")
    List<PaymentHistory> findPaymentHistoriesByLandlord(@Param("username") String username);
}
