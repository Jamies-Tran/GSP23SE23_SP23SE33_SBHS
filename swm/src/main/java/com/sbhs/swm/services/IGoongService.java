package com.sbhs.swm.services;

import com.sbhs.swm.dto.goong.PlacesResult;

public interface IGoongService {
    public PlacesResult getLocationPredictions(String place);
}
