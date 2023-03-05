package com.sbhs.swm.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.sbhs.swm.models.BlocHomestay;

public interface BlocHomestayRepo extends JpaRepository<BlocHomestay, Long> {

    @Query(value = "select b from BlocHomestay b where b.status = 'ACTIVE'")
    List<BlocHomestay> getAllAvailableBlocs();

    @Query(value = "select b from BlocHomestay b where b.address = :address")
    Optional<BlocHomestay> getBlocByAddress(@Param("address") String address);

    @Query(value = "select b from BlocHomestay b where b.name = :name")
    Optional<BlocHomestay> findBlocHomestayByName(@Param("name") String name);

    @Query(value = "select b from BlocHomestay b where b.status = :status")
    Page<BlocHomestay> findBlocHomestaysByStatus(Pageable pageable, @Param("status") String status);

    @Query(value = "select b from BlocHomestay b where b.status = 'ACTIVE' order by b.totalAverageRating desc")
    Page<BlocHomestay> getBlocListOrderByTotalAverageRatingPoint(Pageable pageable);

}
