package com.sbhs.swm.services;

import java.util.List;

import com.sbhs.swm.dto.request.RatingRequestDto;
import com.sbhs.swm.models.Rating;

public interface IRatingService {
    public double calculateHomestayTotalAveragePoint(String name);

    public Rating ratingHomestay(RatingRequestDto ratingRequest);

    public List<Rating> ratingBloc(List<RatingRequestDto> ratingRequestList, String blocName);
}
