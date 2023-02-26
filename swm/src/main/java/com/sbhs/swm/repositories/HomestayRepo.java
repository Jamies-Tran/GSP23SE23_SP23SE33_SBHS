package com.sbhs.swm.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.sbhs.swm.models.Homestay;

public interface HomestayRepo extends JpaRepository<Homestay, Long> {
    @Query(value = "select h from Homestay h where h.name = :name")
    Optional<Homestay> findHomestayByName(@Param("name") String name);

    @Query(value = "select h from Homestay h where h.status = :status")
    Page<Homestay> findHomestaysByStatus(Pageable pageable, @Param("status") String status);

    @Query(value = "select h from Homestay h where h.landlord.user.username=:username")
    Page<Homestay> findHomestaysByLandlordName(Pageable pageable, @Param("username") String name);

    @Query(value = "select h from Homestay h where h.bloc.name = :blocName")
    Page<Homestay> findHomestayByBlocName(Pageable pageable, @Param("blocName") String blocName);

    @Query(value = "select distinct h.cityProvince from Homestay h where h.status = 'ACTIVE'")
    List<String> getHomestayCityOrProvince();

    @Query(value = "select count(h.cityProvince) from Homestay h where h.cityProvince = :location and h.bloc = null and h.status = 'ACTIVE'")
    Integer getTotalHomestayOnLocation(@Param("location") String location);

    @Query(value = "select distinct b.cityProvince from BlocHomestay b where b.status = 'ACTIVE'")
    List<String> getBlocCityOrProvince();

    @Query(value = "select count(b.cityProvince) from BlocHomestay b where b.cityProvince = :location and b.status = 'ACTIVE'")
    Integer getTotalBlocOnLocation(@Param("location") String location);

    @Query(value = "select h from Homestay h order by h.totalAverageRating")
    Page<Homestay> getHomestayListOrderByTotalAverageRatingPoint(Pageable pageable);

}
