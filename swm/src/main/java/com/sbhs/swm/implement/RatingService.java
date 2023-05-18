package com.sbhs.swm.implement;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sbhs.swm.dto.request.RatingRequestDto;
import com.sbhs.swm.models.BlocHomestay;
import com.sbhs.swm.models.Booking;
import com.sbhs.swm.models.BookingHomestay;
import com.sbhs.swm.models.Homestay;
import com.sbhs.swm.models.Rating;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.models.type.HomestayType;
import com.sbhs.swm.repositories.RatingRepo;
import com.sbhs.swm.services.IBookingService;
import com.sbhs.swm.services.IRatingService;
import com.sbhs.swm.services.IUserService;

@Service
public class RatingService implements IRatingService {
    @Autowired
    private RatingRepo ratingRepo;

    @Autowired
    private IUserService userService;

    // @Autowired
    // private IHomestayService homestayService;

    @Autowired
    private IBookingService bookingService;

    @Override
    public double calculateHomestayTotalAveragePoint(String name, String homestayType) {
        double sumOfTotalAverageRating = 0;
        int numberOfRating = 0;
        switch (HomestayType.valueOf(homestayType.toUpperCase())) {
            case HOMESTAY:
                sumOfTotalAverageRating = sumOfTotalAverageRating + ratingRepo.sumAverageRatingPointOfHomestay(name);
                numberOfRating = numberOfRating + ratingRepo.countNumberOfRatingByHomestay(name);
                break;
            case BLOC:
                sumOfTotalAverageRating = sumOfTotalAverageRating + ratingRepo.sumAverageRatingPointOfBloc(name);
                numberOfRating = numberOfRating + ratingRepo.countNumberOfRatingByBloc(name);
                break;
        }

        double totalAverageRating = sumOfTotalAverageRating / numberOfRating;
        return totalAverageRating;
    }

    @Override
    @Transactional
    public Rating ratingHomestay(RatingRequestDto ratingRequest) {
        double averagePoint = (ratingRequest.getSecurityPoint() + ratingRequest.getServicePoint()
                + ratingRequest.getLocationPoint()) / 3;
        SwmUser user = userService.authenticatedUser();
        BookingHomestay bookingHomestay = bookingService.getBookingHomestayByHomestayIdAndBookingId(
                ratingRequest.getBookingId(), ratingRequest.getHomestayId());
        Homestay homestay = bookingHomestay.getHomestay();
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
        rating.setBookingHomestay(bookingHomestay);
        user.getPassengerProperty().setRatings(List.of(rating));
        homestay.setRatings(List.of(rating));
        bookingHomestay.setRating(rating);
        Rating savedRating = ratingRepo.save(rating);
        homestay.setTotalAverageRating(
                this.calculateHomestayTotalAveragePoint(homestay.getName(), HomestayType.HOMESTAY.name()));
        return savedRating;
    }

    @Override
    @Transactional
    public Rating ratingBloc(RatingRequestDto ratingRequest) {
        double averagePoint = (ratingRequest.getSecurityPoint() + ratingRequest.getServicePoint()
                + ratingRequest.getLocationPoint()) / 3;
        SwmUser user = userService.authenticatedUser();
        Booking booking = bookingService.findBookingById(ratingRequest.getBookingId());
        BlocHomestay bloc = booking.getBloc();
        Rating rating = new Rating();
        rating.setAveragePoint(averagePoint);
        rating.setSecurityPoint(ratingRequest.getSecurityPoint());
        rating.setServicePoint(ratingRequest.getServicePoint());
        rating.setLocationPoint(ratingRequest.getLocationPoint());
        if (ratingRequest.getComment() != null) {
            rating.setComment(ratingRequest.getComment());
        }
        rating.setPassenger(user.getPassengerProperty());
        rating.setBloc(bloc);
        rating.setBooking(booking);
        user.getPassengerProperty().setRatings(List.of(rating));
        bloc.setRatings(List.of(rating));
        booking.setRating(rating);
        Rating savedRating = ratingRepo.save(rating);
        bloc.setTotalAverageRating(
                this.calculateHomestayTotalAveragePoint(bloc.getName(), HomestayType.BLOC.name()));
        return savedRating;
    }

}
