package com.sbhs.swm.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.sbhs.swm.models.HomestayService;

public interface HomestayServiceRepo extends JpaRepository<HomestayService, Long> {
    Optional<HomestayService> findHomestayServiceByName(String name);

    @Query(value = "select distinct s.name from HomestayService s where s.homestay.status = 'ACTIVE' and s.homestay.bloc = null")
    List<String> getHomestayServiceDistincNames();

    @Query(value = "select distinct s.name from HomestayService s where s.bloc.status = 'ACTIVE'")
    List<String> getBlocServiceDistincNames();

    @Query(value = "select s.price from HomestayService s where s.homestay.status = 'ACTIVE' and s.homestay.bloc = null order by s.price desc")
    List<Long> getHomestayServiceOrderByPrice();

    @Query(value = "select s.price from HomestayService s where s.bloc.status = 'ACTIVE' order by s.price desc")
    List<Long> getBlocServiceOrderByPrice();
}
