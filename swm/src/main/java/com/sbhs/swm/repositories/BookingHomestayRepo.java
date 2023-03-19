package com.sbhs.swm.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.sbhs.swm.models.BookingHomestay;

public interface BookingHomestayRepo extends JpaRepository<BookingHomestay, Long> {

    @Query(value = "select b from BookingHomestay b where b.homestay.name = :name and b.booking.status != 'SAVED'")
    List<BookingHomestay> findBookingHomestaysByHomestayName(@Param("name") String name);
}
