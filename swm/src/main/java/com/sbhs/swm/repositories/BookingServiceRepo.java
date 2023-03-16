package com.sbhs.swm.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.sbhs.swm.models.BookingHomestayService;

public interface BookingServiceRepo extends JpaRepository<BookingHomestayService, Long> {

}
