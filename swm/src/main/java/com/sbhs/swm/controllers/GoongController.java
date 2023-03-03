package com.sbhs.swm.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.sbhs.swm.dto.goong.DistanceResultRows;
import com.sbhs.swm.dto.goong.PlacesResult;
import com.sbhs.swm.services.IGoongService;

@RestController
@RequestMapping("/api/map")
public class GoongController {
    @Autowired
    private IGoongService goongService;

    @GetMapping
    public ResponseEntity<?> getAutoCompletePlaces(@RequestParam String place) {
        PlacesResult placesResult = goongService.getLocationPredictions(place);

        return new ResponseEntity<PlacesResult>(placesResult, HttpStatus.OK);
    }

    @PostMapping("/test-distance")
    public ResponseEntity<?> test(@RequestParam String origin, @RequestBody List<String> addresses) {

        DistanceResultRows distanceResult = goongService.getDistanceFromLocation(origin, addresses, true);

        return new ResponseEntity<DistanceResultRows>(distanceResult, HttpStatus.OK);
    }
}
