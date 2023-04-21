package com.sbhs.swm.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.sbhs.swm.models.BookingHomestayId;
import com.sbhs.swm.models.BookingHomestayService;

public interface BookingServiceRepo extends JpaRepository<BookingHomestayService, BookingHomestayId> {
        @Query(value = "delete from BookingHomestayService b where b.booking.id = :bookingId and b.homestayService.id = :serviceId")
        @Modifying
        void deleteBookingHomestayServiceByBookingIdAndServiceId(@Param("bookingId") Long bookingId,
                        @Param("serviceId") Long serviceId);

        @Query(value = "delete from BookingHomestayService b where b.booking.id = :id")
        @Modifying
        void deleteBookingHomestayService(@Param("id") Long id);

        @Query(value = "delete from BookingHomestayService b where b.booking.id = :id and b.homestayName = :homestayName")
        @Modifying
        void deleteBookingHomestayServiceByBookingIdAndHomestayName(@Param("id") Long id,
                        @Param("homestayName") String homestayName);
}
