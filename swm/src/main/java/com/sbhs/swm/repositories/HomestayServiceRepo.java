package com.sbhs.swm.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.sbhs.swm.models.HomestayService;

public interface HomestayServiceRepo extends JpaRepository<HomestayService, Long> {
    Optional<HomestayService> findHomestayServiceByName(String name);

    @Query(value = "select distinct s.name from HomestayService s where s.homestay.status = 'ACTIVE'")
    List<String> getHomestayServiceDistincNames();

    @Query(value = "select s.price from HomestayService s where s.homestay.status = 'ACTIVE' order by s.price desc")
    List<Long> getHomestayServiceOrderByPrice();
}
