package com.sbhs.swm.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.sbhs.swm.models.HomestayFacility;

public interface HomestayFacilityRepo extends JpaRepository<HomestayFacility, Long> {
    @Query(value = "select distinct f.name from HomestayFacility f where f.homestay.status = 'ACTIVE'")
    List<String> getHomestayFacilityDistincNames();
}
