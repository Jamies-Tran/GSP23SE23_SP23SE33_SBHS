package com.sbhs.swm.repositories;

import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.sbhs.swm.models.PaymentHistory;

public interface PaymentRepo extends JpaRepository<PaymentHistory, Long> {

    @Query(value = "select p from PaymentHistory p where p.passengerWallet.passengerBalanceWallet.passenger.user.username = :username")
    Page<PaymentHistory> findPaymentHistoriesByPassenger(Pageable pageable, @Param("username") String username);

    @Query(value = "select p from PaymentHistory p where p.landlordWallet.landlordBalanceWallet.landlord.user.username = :username")
    Page<PaymentHistory> findPaymentHistoriesByLandlord(Pageable pageable, @Param("username") String username);

    @Query(value = "select p from PaymentHistory p where p.orderId = :orderId")
    Optional<PaymentHistory> findPaymentHistoryByOrderId(@Param("orderId") String orderId);
}
