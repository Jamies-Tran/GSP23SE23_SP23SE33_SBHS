package com.sbhs.swm.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

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

    // @GetMapping("/test-distance")
    // public ResponseEntity<?> test(@RequestParam String origin) {
    // List<String> addresses = List.of("Lăng Bác, Hùng Vương, Điện Biên, Ba Đình",
    // "Sân bay Quốc tế Cần Thơ (VCA), Trà An, Bình Thủy",
    // "Bệnh viện Đa khoa tỉnh Gia Lai, Tôn Thất Tùng, Phù Đổng, Pleiku");
    // DistanceResultRows distanceResult =
    // goongService.getDistanceFromLocation(origin, addresses);

    // return new ResponseEntity<DistanceResultRows>(distanceResult, HttpStatus.OK);
    // }
}
