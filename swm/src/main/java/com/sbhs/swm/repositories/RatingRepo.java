package com.sbhs.swm.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.sbhs.swm.models.Rating;

public interface RatingRepo extends JpaRepository<Rating, Long> {
    @Query(value = "select sum(r.averagePoint) from Rating r where r.homestay.name = :name")
    Double sumAverageRatingPointOfHomestay(@Param("name") String name);
}
