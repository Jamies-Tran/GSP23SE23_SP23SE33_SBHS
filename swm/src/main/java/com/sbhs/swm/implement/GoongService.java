package com.sbhs.swm.implement;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.sbhs.swm.dto.goong.DistanceResultRows;
import com.sbhs.swm.dto.goong.GeometryResultList;
import com.sbhs.swm.dto.goong.PlacesResult;

import com.sbhs.swm.services.IGoongService;

@Service
public class GoongService implements IGoongService {

    @Value("${goong.apikey}")
    private String goongApiKey;

    private final String PLACES_URL = "https://rsapi.goong.io/Place/AutoComplete";

    private final String DISTANCE_URL = "https://rsapi.goong.io/DistanceMatrix";

    private final String GEOCODING_URL = "https://rsapi.goong.io/geocode";

    @Autowired
    private RestTemplate restTemplate;

    @Override
    public PlacesResult getLocationPredictions(String place) {
        StringBuilder apiUrlBuilder = new StringBuilder();
        apiUrlBuilder.append(PLACES_URL).append("?api_key=").append(goongApiKey)
                .append("&input=").append(place);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        PlacesResult result = restTemplate.getForObject(apiUrlBuilder.toString(), PlacesResult.class, headers);

        return result;
    }

    @Override
    public DistanceResultRows getDistanceFromLocation(String origins, List<String> destinations, boolean isGeometry) {
        String geometryAddressOrigin = isGeometry ? this.convertAddressToGeometry(origins) : origins;
        List<String> geometryAddressDestinations = destinations.stream().map(d -> d.split("-")[1])
                .collect(Collectors.toList());
        StringBuilder apiUrlBuilder = new StringBuilder();
        StringBuilder destinationBuilder = new StringBuilder();
        if (geometryAddressDestinations.size() == 1) {
            destinationBuilder.append(geometryAddressDestinations.get(0));
        } else {
            for (int i = 0; i < geometryAddressDestinations.size(); i++) {
                if (i == (geometryAddressDestinations.size() - 1)) {
                    destinationBuilder.append(geometryAddressDestinations.get(i));
                } else {
                    destinationBuilder.append(geometryAddressDestinations.get(i)).append("|");
                }
            }
        }
        apiUrlBuilder.append(DISTANCE_URL).append("?origins=").append(geometryAddressOrigin)
                .append("&destinations=").append(destinationBuilder.toString()).append("&vehicle=car")
                .append("&api_key=").append(goongApiKey);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        DistanceResultRows distanceResultRows = restTemplate.getForObject(apiUrlBuilder.toString(),
                DistanceResultRows.class, headers);
        for (int i = 0; i < destinations.size(); i++) {
            distanceResultRows.getRows().get(0).getElements().get(i).setAddress(destinations.get(i));
        }

        return distanceResultRows;
    }

    @Override
    public String convertAddressToGeometry(String address) {
        StringBuilder apiUrlBuilder = new StringBuilder();
        StringBuilder latlngBuilder = new StringBuilder();

        apiUrlBuilder.append(GEOCODING_URL).append("?address=").append(address).append("&api_key=").append(goongApiKey);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        GeometryResultList geometryResultList = restTemplate.getForObject(apiUrlBuilder.toString(),
                GeometryResultList.class, headers);
        latlngBuilder.append(geometryResultList.getResults().get(0).getGeometry().getLocation().getLat()).append(",")
                .append(geometryResultList.getResults().get(0).getGeometry().getLocation().getLng());
        return latlngBuilder.toString();
    }

}
