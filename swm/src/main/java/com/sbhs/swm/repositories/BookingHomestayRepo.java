package com.sbhs.swm.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.google.common.base.Optional;
import com.sbhs.swm.models.BookingHomestay;

public interface BookingHomestayRepo extends JpaRepository<BookingHomestay, Long> {

    @Query(value = "select b from BookingHomestay b where b.homestay.name = :name and b.booking.status != 'SAVED'")
    List<BookingHomestay> findBookingHomestaysByHomestayName(@Param("name") String name);

    @Query(value = "select b from BookingHomestay b where b.homestay.id = :homestayId and b.booking.id = :bookingId")
    Optional<BookingHomestay> findBookingHomestayById(@Param("bookingId") Long bookingId,
            @Param("homestayId") Long homestayId);

    @Query(value = "delete from BookingHomestay b where b.booking.id = :bookingId and b.homestay.id = :homestayId")
    @Modifying
    void deleteBookingHomestayById(@Param("bookingId") Long bookingId, @Param("homestayId") Long homestayId);

}
