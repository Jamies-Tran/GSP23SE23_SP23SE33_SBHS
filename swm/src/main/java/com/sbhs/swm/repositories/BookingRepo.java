package com.sbhs.swm.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.sbhs.swm.models.Booking;

public interface BookingRepo extends JpaRepository<Booking, Long> {
    @Query(value = "select b from Booking b where b.passenger.user.username = :username")
    List<Booking> findBookingListByUsername(@Param("username") String username);

    @Query(value = "select b from Booking b where b.homestay.name = :name")
    List<Booking> findAllHomestayBooking(@Param("name") String homestay);

    @Query(value = "select sum(b.totalRoom) from Booking b where b.homestay.name = :name")
    Integer totalHomestayRoomBooked(@Param("name") String homestayName);

    @Query(value = "select sum(b.totalRoom) from Booking b where b.homestay.name = :name and b.bookingTo = :checkout")
    Integer totalHomestayRoomWillBeCheckedOut(@Param("name") String homestayName, @Param("checkout") String bookingEnd);
}
