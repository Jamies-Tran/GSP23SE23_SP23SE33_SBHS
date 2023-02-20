package com.sbhs.swm.implement;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.sbhs.swm.dto.goong.PlacesResult;

import com.sbhs.swm.services.IGoongService;

@Service
public class GoongService implements IGoongService {

    @Value("${goong.apikey}")
    private String goongApiKey;

    @Autowired
    private RestTemplate restTemplate;

    // "https://rsapi.goong.io/Place/AutoComplete?api_key={YOUR_API_KEY}&location=21.013715429594125,%20105.79829597455202&input=91%20Trung%20Kinh"

    @Override
    public PlacesResult getLocationPredictions(String place) {
        StringBuilder goongPlacesApiUrl = new StringBuilder();
        goongPlacesApiUrl.append("https://rsapi.goong.io/Place/AutoComplete?api_key=").append(goongApiKey)
                .append("&input=").append(place);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        PlacesResult result = restTemplate.getForObject(goongPlacesApiUrl.toString(), PlacesResult.class, headers);

        return result;
    }

}
