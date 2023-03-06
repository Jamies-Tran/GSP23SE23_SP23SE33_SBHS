package com.sbhs.swm.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.sbhs.swm.models.HomestayFacility;

public interface HomestayFacilityRepo extends JpaRepository<HomestayFacility, Long> {
    @Query(value = "select distinct f.name from HomestayFacility f where f.homestay.status = 'ACTIVE' and f.homestay.bloc = null")
    List<String> getHomestayFacilityDistincNames();

    @Query(value = "select distinct f.name from HomestayFacility f where f.homestay.bloc != null and f.homestay.bloc.status = 'ACTIVE'")
    List<String> getBlocFacilityDistincNames();
}
