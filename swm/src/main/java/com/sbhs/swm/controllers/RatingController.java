package com.sbhs.swm.controllers;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sbhs.swm.dto.request.RatingRequestDto;
import com.sbhs.swm.dto.response.RatingResponseDto;
import com.sbhs.swm.models.Rating;
import com.sbhs.swm.services.IRatingService;

@RestController
@RequestMapping("/api/rating")
public class RatingController {
    @Autowired
    private IRatingService ratingService;

    @Autowired
    private ModelMapper modelMapper;

    @PostMapping("/homestay")
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> ratingHomestay(@RequestBody RatingRequestDto ratingRequest) {
        Rating rating = ratingService.ratingHomestay(ratingRequest);
        RatingResponseDto responseRating = modelMapper.map(rating, RatingResponseDto.class);

        return new ResponseEntity<RatingResponseDto>(responseRating, HttpStatus.OK);
    }

    @PostMapping("/bloc")
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> ratingBlocHomestay(@RequestBody RatingRequestDto ratingRequest) {
        Rating rating = ratingService.ratingBloc(ratingRequest);
        RatingResponseDto responseRating = modelMapper.map(rating, RatingResponseDto.class);

        return new ResponseEntity<RatingResponseDto>(responseRating, HttpStatus.OK);
    }
}
