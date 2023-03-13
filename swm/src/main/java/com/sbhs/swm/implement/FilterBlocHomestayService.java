package com.sbhs.swm.implement;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sbhs.swm.dto.goong.DistanceElement;
import com.sbhs.swm.dto.goong.DistanceResultRows;
import com.sbhs.swm.handlers.exceptions.InvalidBookingException;
import com.sbhs.swm.models.BlocHomestay;

import com.sbhs.swm.models.Homestay;
import com.sbhs.swm.models.HomestayFacility;
import com.sbhs.swm.models.HomestayService;

import com.sbhs.swm.repositories.BlocHomestayRepo;

import com.sbhs.swm.services.IFilterBlocHomestayService;
import com.sbhs.swm.services.IGoongService;
import com.sbhs.swm.util.BookingDateValidationString;
import com.sbhs.swm.util.BookingDateValidationUtil;

@Service
public class FilterBlocHomestayService implements IFilterBlocHomestayService {

    @Autowired
    private BlocHomestayRepo blocHomestayRepo;

    @Autowired
    private BookingDateValidationUtil bookingDateValidationUtil;

    @Autowired
    private IGoongService goongService;

    @Override
    public List<BlocHomestay> filterBlocByBookingDateRange(List<BlocHomestay> blocs, String bookingStart,
            String bookingEnd, int totalBookingRoom) {
        blocs = blocs.stream().filter(b -> checkValidBookingBloc(b, bookingStart, bookingEnd, totalBookingRoom))
                .collect(Collectors.toList());
        return blocs;
    }

    /* check if bloc still have homestay free schedule - start */
    private boolean checkValidBookingBloc(BlocHomestay bloc, String bookingStart, String bookingEnd,
            int totalHomestay) {
        int totalBookedBloc = this.totalHomestayInBlockBooked(bloc.getName(), bookingStart, bookingEnd);
        int availableHomestay = blocHomestayRepo.getAllAvailableBlocs().size() - totalBookedBloc;

        if (availableHomestay == 0 || availableHomestay > totalHomestay) {
            return false;
        }

        return true;
    }

    private Integer totalHomestayInBlockBooked(String name, String bookingStart, String bookingEnd) {
        List<Homestay> homestaysInBlockBooked = blocHomestayRepo.getAllAvailableBlocs().stream().filter(b -> {
            if (b.getName().equals(name)) {
                if (b.getHomestays().stream().anyMatch(h -> this.isHomestayBooked(h, bookingStart, bookingEnd))) {
                    return true;
                } else {
                    return false;
                }
            }
            return false;
        }).map(b -> b.getHomestays()).findFirst().get();

        return homestaysInBlockBooked.size();
    }

    private boolean isHomestayBooked(Homestay homestay, String bookingStart, String bookingEnd) {
        String validateHomestayBookingString = bookingDateValidationUtil.bookingValidateString(bookingStart, bookingEnd,
                homestay.getName());
        switch (BookingDateValidationString.valueOf(validateHomestayBookingString)) {
            case CURRENT_END_ON_BOOKED_END:
                return true;
            case CURRENT_START_ON_BOOKED_END:
                return false;
            case CURRENT_START_ON_BOOKED_START:
                return true;
            case ON_BOOKING_PERIOD:
                return true;
            case OK:
                return false;
            case INVALID:
                throw new InvalidBookingException("Invalid booking date");
        }
        return false;
    }

    /* check if bloc still have homestay free schedule - end */

    @Override
    public List<BlocHomestay> filterByRatingRange(List<BlocHomestay> blocs, double lowest, double highest) {
        blocs = blocs.stream().filter(b -> b.getTotalAverageRating() >= lowest && b.getTotalAverageRating() <= highest)
                .collect(Collectors.toList());
        return blocs;
    }

    @Override
    public List<BlocHomestay> filterByAddress(List<BlocHomestay> blocs, String address, int distance,
            boolean isGeometry) {
        List<String> destinations = blocs.stream().map(h -> h.getAddress())
                .collect(Collectors.toList());
        DistanceResultRows distanceResultRows = goongService.getDistanceFromLocation(address, destinations, isGeometry);
        List<DistanceElement> distanceElements = distanceResultRows.getRows().get(0).getElements().stream()
                .filter(e -> e.getDistance().getValue() <= distance).collect(Collectors.toList());
        blocs = distanceElements.stream()
                .map(d -> blocHomestayRepo.findBlocHomestayByAddress(d.getAddress()).get())
                .collect(Collectors.toList());
        return blocs;
    }

    @Override
    public List<BlocHomestay> filterByPriceRange(List<BlocHomestay> blocs, long lowest, long heighest) {
        blocs = blocs.stream().filter(b -> isBlocHaveHomestayInPriceRange(b, lowest, heighest))
                .collect(Collectors.toList());

        return blocs;
    }

    private boolean isBlocHaveHomestayInPriceRange(BlocHomestay bloc, long lowest, long highest) {
        for (Homestay h : bloc.getHomestays()) {
            if (h.getPrice() >= lowest && h.getPrice() <= highest) {
                return true;
            }
        }
        return false;
    }

    @Override
    public List<BlocHomestay> filterByFacility(List<BlocHomestay> blocs, String name, int quantity) {
        blocs = blocs.stream().filter(b -> isHomestayInBlocHaveFacility(b, name, quantity))
                .collect(Collectors.toList());
        return blocs;
    }

    private boolean isHomestayInBlocHaveFacility(BlocHomestay bloc, String name, int quantity) {
        for (Homestay h : bloc.getHomestays()) {
            for (HomestayFacility f : h.getHomestayFacilities()) {
                if (f.getName().equalsIgnoreCase(name) && f.getQuantity() >= quantity) {
                    return true;
                }
            }
        }
        return false;
    }

    @Override
    public List<BlocHomestay> filterByBlocService(List<BlocHomestay> blocs, String name, long price) {
        blocs = blocs.stream().filter(b -> {
            for (HomestayService s : b.getHomestayServices()) {
                if (s.getName().equalsIgnoreCase(name) && s.getPrice() == price) {
                    return true;
                }
            }
            return false;
        }).collect(Collectors.toList());

        return blocs;
    }

    @Override
    public List<BlocHomestay> filterBySearchString(List<BlocHomestay> blocs, String searchString) {
        blocs = blocs.stream().filter(b -> {

            if (this.isSearchStringFindHomestayInBloc(b, searchString)
                    || b.getCityProvince().equalsIgnoreCase(searchString)
                    || b.getName().toLowerCase().contains(searchString)
                    || b.getAddress().toLowerCase().contains(searchString)) {
                return true;
            }
            return false;
        }).collect(Collectors.toList());

        return blocs;
    }

    private boolean isSearchStringFindHomestayInBloc(BlocHomestay bloc, String searchString) {
        for (Homestay h : bloc.getHomestays()) {
            if (h.getName().toLowerCase().contains(searchString)) {
                return true;
            }
        }

        return false;
    }
}
