package com.sbhs.swm.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.sbhs.swm.models.BookingHomestay;
import com.sbhs.swm.models.BookingHomestayId;

public interface BookingHomestayRepo extends JpaRepository<BookingHomestay, BookingHomestayId> {

        @Query(value = "select b from BookingHomestay b where b.homestay.id = :homestayId and b.booking.id = :bookingId")
        Optional<BookingHomestay> findBookingHomestayById(@Param("bookingId") Long bookingId,
                        @Param("homestayId") Long homestayId);

        @Query(value = "select b from BookingHomestay b where b.homestay.name = :homestayName and b.status = :status")
        List<BookingHomestay> findBookingHomestayByHomestayNameAndStatus(@Param("homestayName") String homestayName,
                        @Param("status") String status);

        @Query(value = "Select b from BookingHomestay b where b.homestay.name = :homestayName and b.status = :status")
        List<BookingHomestay> checkPendingBookingHomestay(
                        @Param("homestayName") String homestayName, @Param("status") String status);

        @Query(value = "delete from BookingHomestay b where b.booking.id = :bookingId and b.homestay.id = :homestayId")
        @Modifying
        void deleteBookingHomestayById(@Param("bookingId") Long bookingId, @Param("homestayId") Long homestayId);

}
