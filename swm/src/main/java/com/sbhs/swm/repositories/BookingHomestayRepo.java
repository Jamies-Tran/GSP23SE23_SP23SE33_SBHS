package com.sbhs.swm.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.google.common.base.Optional;
import com.sbhs.swm.models.BookingHomestay;

public interface BookingHomestayRepo extends JpaRepository<BookingHomestay, Long> {

        @Query(value = "select b from BookingHomestay b where b.homestay.id = :homestayId and b.booking.id = :bookingId")
        Optional<BookingHomestay> findBookingHomestayById(@Param("bookingId") Long bookingId,
                        @Param("homestayId") Long homestayId);

        @Query(value = "select b from BookingHomestay b where b.homestay.name = :homestayName and b.status = :status")
        List<BookingHomestay> findBookingHomestayByHomestayName(@Param("homestayName") String homestayName,
                        @Param("status") String status);

        @Query(value = "select count(b) from BookingHomestay b where b.homestay.name = :homestayName and b.booking.status = 'PENDING'")
        Integer countBookingHomestayPending(@Param("homestayName") String homestayName);

        @Query(value = "delete from BookingHomestay b where b.booking.id = :bookingId and b.homestay.id = :homestayId")
        @Modifying
        void deleteBookingHomestayById(@Param("bookingId") Long bookingId, @Param("homestayId") Long homestayId);

}
