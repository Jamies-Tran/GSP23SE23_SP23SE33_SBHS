package com.sbhs.swm.services;

import java.util.List;

import com.sbhs.swm.dto.goong.DistanceResultRows;
import com.sbhs.swm.dto.goong.PlacesResult;

public interface IGoongService {
    public PlacesResult getLocationPredictions(String place);

    public DistanceResultRows getDistanceFromLocation(String origins, List<String> destinations);

    public String convertAddressToGeometry(String address);
}
