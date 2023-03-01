package com.sbhs.swm.repositories;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.sbhs.swm.models.HomestayService;

public interface HomestayServiceRepo extends JpaRepository<HomestayService, Long> {
    Optional<HomestayService> findHomestayServiceByName(String name);
}
