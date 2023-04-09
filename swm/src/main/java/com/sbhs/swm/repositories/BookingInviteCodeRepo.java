package com.sbhs.swm.repositories;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.sbhs.swm.models.BookingInviteCode;

public interface BookingInviteCodeRepo extends JpaRepository<BookingInviteCode, Long> {
    @Query(value = "select c from BookingInviteCode c where c.inviteCode = :inviteCode")
    Optional<BookingInviteCode> findBookingInviteCodeByCode(@Param("inviteCode") String inviteCode);
}
