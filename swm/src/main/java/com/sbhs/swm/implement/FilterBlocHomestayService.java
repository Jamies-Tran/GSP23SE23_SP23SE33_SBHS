package com.sbhs.swm.implement;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sbhs.swm.dto.goong.DistanceElement;
import com.sbhs.swm.dto.goong.DistanceResultRows;
import com.sbhs.swm.handlers.exceptions.InvalidBookingException;
import com.sbhs.swm.handlers.exceptions.NotFoundException;
import com.sbhs.swm.models.BlocHomestay;
import com.sbhs.swm.models.BookingHomestay;
import com.sbhs.swm.models.Homestay;
import com.sbhs.swm.models.HomestayFacility;
import com.sbhs.swm.models.HomestayService;
import com.sbhs.swm.models.PromotionCampaign;
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
            String bookingEnd, int getTotalReservation) {
        blocs = blocs.stream().filter(b -> checkValidBookingBloc(b, bookingStart, bookingEnd, getTotalReservation))
                .collect(Collectors.toList());
        return blocs;
    }

    /* check if bloc still have homestay free schedule - start */
    private boolean checkValidBookingBloc(BlocHomestay bloc, String bookingStart, String bookingEnd,
            int totalReservation) {
        List<Homestay> availableHomestayList = this.getAllAvailableHomestayInBlock(bloc.getName(), bookingStart,
                bookingEnd);
        int totalCurrentCapacityOfBloc = 0;
        for (Homestay h : availableHomestayList) {
            int totalHomestayCapacity = h.getAvailableRooms() * h.getRoomCapacity();
            totalCurrentCapacityOfBloc = totalCurrentCapacityOfBloc + totalHomestayCapacity;
        }
        if (totalCurrentCapacityOfBloc == 0 || totalCurrentCapacityOfBloc < totalReservation) {
            return false;
        }

        return true;
    }

    private List<Homestay> getAllAvailableHomestayInBlock(String name, String bookingStart, String bookingEnd) {
        BlocHomestay bloc = blocHomestayRepo.findBlocHomestayByName(name)
                .orElseThrow(() -> new NotFoundException("can't find bloc"));
        List<Homestay> homestayList = bloc.getHomestays().stream()
                .filter(h -> isHomestayAvailable(h, bookingStart, bookingEnd)).collect(Collectors.toList());
        return homestayList;
    }

    private boolean isHomestayAvailable(Homestay homestay, String bookingStart, String bookingEnd) {
        for (BookingHomestay b : homestay.getBookingHomestays()) {
            String validateHomestayBookingString = bookingDateValidationUtil.bookingValidateString(bookingStart,
                    bookingEnd, b);
            switch (BookingDateValidationString.valueOf(validateHomestayBookingString)) {
                case CURRENT_END_ON_BOOKED_END:
                    return false;
                case CURRENT_START_ON_BOOKED_END:
                    break;
                case CURRENT_START_ON_BOOKED_START:
                    return false;
                case ON_BOOKING_PERIOD:
                    return false;
                case OK:
                    break;
                case INVALID:
                    throw new InvalidBookingException("Invalid booking date");
            }
        }

        return true;
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
        Collections.sort(distanceElements, new Comparator<DistanceElement>() {

            @Override
            public int compare(DistanceElement d1, DistanceElement d2) {
                return d1.getDistance().getValue().compareTo(d2.getDistance().getValue());
            }

        });
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
            if (b.getCampaigns() != null) {
                for (PromotionCampaign c : b.getCampaigns()) {
                    if (c.getName().equals(searchString)) {
                        return true;
                    }
                }
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
