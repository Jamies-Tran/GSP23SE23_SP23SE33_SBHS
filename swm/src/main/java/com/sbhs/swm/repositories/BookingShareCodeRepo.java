package com.sbhs.swm.repositories;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.sbhs.swm.models.BookingShareCode;

public interface BookingShareCodeRepo extends JpaRepository<BookingShareCode, Long> {
    @Query(value = "select c from BookingShareCode c where c.shareCode = :shareCode")
    Optional<BookingShareCode> findBookingShareCodeByCode(@Param("shareCode") String shareCode);
}
