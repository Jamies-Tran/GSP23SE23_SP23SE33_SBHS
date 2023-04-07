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

    @Query(value = "select h from Homestay h where h.status = 'ACTIVATING' and h.bloc = null")
    List<Homestay> getAllAvailableHomestay();

    @Query(value = "select h from Homestay h where h.name = :name")
    Optional<Homestay> findHomestayByName(@Param("name") String name);

    @Query(value = "select distinct h.cityProvince from Homestay h where h.status = 'ACTIVATING' and h.bloc = null")
    List<String> getHomestayCityOrProvince();

    @Query(value = "select count(h.cityProvince) from Homestay h where h.cityProvince = :location and h.bloc = null and h.status = 'ACTIVATING'")
    Integer getTotalHomestayOnLocation(@Param("location") String location);

    @Query(value = "select distinct b.cityProvince from BlocHomestay b where b.status = 'ACTIVATING'")
    List<String> getBlocCityOrProvince();

    @Query(value = "select count(b.cityProvince) from BlocHomestay b where b.cityProvince = :location and b.status = 'ACTIVATING'")
    Integer getTotalBlocOnLocation(@Param("location") String location);

    @Query(value = "select h from Homestay h where h.status = 'ACTIVATING' and h.bloc = null order by h.totalAverageRating desc")
    Page<Homestay> getHomestayListOrderByTotalAverageRatingPoint(Pageable pageable);

    @Query(value = "select h from Homestay h where h.address = :address")
    Optional<Homestay> findHomestayByAddress(@Param("address") String address);

    @Query(value = "select h.price from Homestay h where h.status = 'ACTIVATING' and h.bloc = null order by h.price desc")
    List<Long> getHomestayOrderByPrice();

    @Query(value = "select h.price from Homestay h where h.status = 'ACTIVATING' order by h.price desc")
    List<Long> getAllHomestayOrderByPrice();
}
