package com.sbhs.swm.implement;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sbhs.swm.dto.request.RatingRequestDto;
import com.sbhs.swm.models.BlocHomestay;
import com.sbhs.swm.models.Homestay;
import com.sbhs.swm.models.Rating;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.repositories.RatingRepo;
import com.sbhs.swm.services.IHomestayService;
import com.sbhs.swm.services.IRatingService;
import com.sbhs.swm.services.IUserService;

@Service
public class RatingService implements IRatingService {
    @Autowired
    private RatingRepo ratingRepo;

    @Autowired
    private IUserService userService;

    @Autowired
    private IHomestayService homestayService;

    @Override
    public double calculateHomestayTotalAveragePoint(String name) {
        double sumOfTotalAverageRating = ratingRepo.sumAverageRatingPointOfHomestay(name);
        double totalAverageRating = sumOfTotalAverageRating / ratingRepo.findAll().size();
        return totalAverageRating;
    }

    @Override
    @Transactional
    public Rating ratingHomestay(RatingRequestDto ratingRequest) {
        double averagePoint = (ratingRequest.getSecurityPoint() + ratingRequest.getServicePoint()
                + ratingRequest.getLocationPoint()) / 3;
        SwmUser user = userService.authenticatedUser();
        Homestay homestay = homestayService.findHomestayByName(ratingRequest.getHomestayName());
        Rating rating = new Rating();
        rating.setAveragePoint(averagePoint);
        rating.setSecurityPoint(ratingRequest.getSecurityPoint());
        rating.setServicePoint(ratingRequest.getServicePoint());
        rating.setLocationPoint(ratingRequest.getLocationPoint());
        if (ratingRequest.getComment() != null) {
            rating.setComment(ratingRequest.getComment());
        }
        rating.setPassenger(user.getPassengerProperty());
        rating.setHomestay(homestay);
        user.getPassengerProperty().setRatings(List.of(rating));
        homestay.setRatings(List.of(rating));
        Rating savedRating = ratingRepo.save(rating);
        homestay.setTotalAverageRating(this.calculateHomestayTotalAveragePoint(ratingRequest.getHomestayName()));
        return savedRating;
    }

    @Override
    @Transactional
    public List<Rating> ratingBloc(List<RatingRequestDto> ratingRequestList, String blocName) {
        SwmUser user = userService.authenticatedUser();
        List<Rating> ratingList = new ArrayList<>();
        BlocHomestay bloc = homestayService.findBlocHomestayByName(blocName);
        double blocSecurityPoint = 0;
        double blocServicePoint = 0;
        double blocLocationPoint = 0;
        for (RatingRequestDto r : ratingRequestList) {
            double average = (r.getSecurityPoint() + r.getServicePoint() + r.getLocationPoint()) / 3;
            Rating rating = new Rating();
            Homestay homestay = homestayService.findHomestayByName(r.getHomestayName());
            rating.setAveragePoint(average);
            rating.setSecurityPoint(r.getSecurityPoint());
            rating.setServicePoint(r.getServicePoint());
            rating.setLocationPoint(r.getLocationPoint());
            if (r.getComment() != null) {
                rating.setComment(r.getComment());
            }
            rating.setHomestay(homestay);
            rating.setPassenger(user.getPassengerProperty());
            ratingList.add(rating);
            homestay.setRatings(ratingList);
            homestay.setTotalAverageRating(this.calculateHomestayTotalAveragePoint(r.getHomestayName()));
        }
        user.getPassengerProperty().setRatings(ratingList);
        List<Rating> savedRating = ratingRepo.saveAll(ratingList);
        for (Rating r : savedRating) {
            blocSecurityPoint = blocSecurityPoint + r.getSecurityPoint();
            blocServicePoint = blocServicePoint + r.getServicePoint();
            blocLocationPoint = blocLocationPoint + r.getLocationPoint();
        }
        double blocAveragePoint = (blocSecurityPoint + blocServicePoint + blocLocationPoint) / 3;
        Rating savedBlocRating = new Rating();
        savedBlocRating.setAveragePoint(blocAveragePoint);
        savedBlocRating.setSecurityPoint(blocSecurityPoint);
        savedBlocRating.setServicePoint(blocServicePoint);
        savedBlocRating.setLocationPoint(blocLocationPoint);
        savedBlocRating.setPassenger(user.getPassengerProperty());
        savedBlocRating.setBloc(bloc);
        bloc.setRatings(List.of(savedBlocRating));
        bloc.setTotalAverageRating(this.calculateHomestayTotalAveragePoint(blocName));
        user.getPassengerProperty().setRatings(List.of(savedBlocRating));
        ratingRepo.save(savedBlocRating);

        return savedRating;
    }

}
