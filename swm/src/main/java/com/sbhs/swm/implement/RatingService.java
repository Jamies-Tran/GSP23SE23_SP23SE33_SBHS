package com.sbhs.swm.implement;

import org.springframework.beans.factory.annotation.Autowired;

import com.sbhs.swm.repositories.RatingRepo;
import com.sbhs.swm.services.IRatingService;

public class RatingService implements IRatingService {
    @Autowired
    private RatingRepo ratingRepo;

    @Override
    public double calculateHomestayTotalAveragePoint(String name) {
        double sumOfTotalAverageRating = ratingRepo.sumAverageRatingPointOfHomestay(name);
        double totalAverageRating = sumOfTotalAverageRating / ratingRepo.findAll().size();
        return totalAverageRating;
    }

}
