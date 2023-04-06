package com.sbhs.swm.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.sbhs.swm.models.HomestayService;

public interface HomestayServiceRepo extends JpaRepository<HomestayService, Long> {

    @Query(value = "select s from HomestayService s where s.name = :name")
    Optional<HomestayService> findHomestayServiceByName(@Param("name") String name);

    // @Query(value = "select s from HomestayService s where s.name = :serviceName
    // and (s.homestay.name = :homestayName or s.bloc.name = :homestayName)")
    // Optional<HomestayService>
    // findHomestayServiceByServiceNameAndHomestayName(@Param("serviceName") String
    // serviceName,
    // @Param("homestayName") String homestayName);

    @Query(value = "select distinct s.name from HomestayService s where s.homestay.status = 'ACTIVATING' and s.homestay.bloc = null")
    List<String> findHomestayServiceDistincNames();

    @Query(value = "select distinct s.name from HomestayService s where s.bloc.status = 'ACTIVATING'")
    List<String> findBlocServiceDistincNames();

    @Query(value = "select s.price from HomestayService s where s.homestay.status = 'ACTIVATING' and s.homestay.bloc = null order by s.price desc")
    List<Long> findHomestayServiceOrderByPrice();

    @Query(value = "select s.price from HomestayService s where s.bloc.status = 'ACTIVATING' order by s.price desc")
    List<Long> findBlocServiceOrderByPrice();
}
