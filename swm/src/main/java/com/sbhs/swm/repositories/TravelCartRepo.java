package com.sbhs.swm.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.sbhs.swm.models.TravelCart;

public interface TravelCartRepo extends JpaRepository<TravelCart, Long> {

}
