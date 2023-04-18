package com.sbhs.swm.services;

import com.sbhs.swm.dto.request.RatingRequestDto;
import com.sbhs.swm.models.Rating;

public interface IRatingService {
    public double calculateHomestayTotalAveragePoint(String name, String homestayType);

    public Rating ratingHomestay(RatingRequestDto ratingRequest);

    public Rating ratingBloc(RatingRequestDto ratingRequest);
}
