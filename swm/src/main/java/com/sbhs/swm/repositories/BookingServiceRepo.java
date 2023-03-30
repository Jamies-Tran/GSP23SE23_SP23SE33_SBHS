package com.sbhs.swm.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.sbhs.swm.models.BookingHomestayService;

public interface BookingServiceRepo extends JpaRepository<BookingHomestayService, Long> {
    @Query(value = "delete from BookingHomestayService b where b.booking.id = :id")
    @Modifying
    void deleteBookingHomestayService(@Param("id") Long bookingId);
}
