package com.sbhs.swm.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.sbhs.swm.models.Booking;

public interface BookingRepo extends JpaRepository<Booking, Long> {

    @Query(value = "select b from Booking b where b.passenger.user.username = :username and b.status = :status")
    List<Booking> findBookingByUsernameAndStatus(@Param("username") String username, @Param("status") String status);
}
