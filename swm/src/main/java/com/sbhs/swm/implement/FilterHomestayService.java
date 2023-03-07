package com.sbhs.swm.implement;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sbhs.swm.dto.goong.DistanceElement;
import com.sbhs.swm.dto.goong.DistanceResultRows;
import com.sbhs.swm.models.Booking;
import com.sbhs.swm.models.Homestay;
import com.sbhs.swm.models.HomestayFacility;
import com.sbhs.swm.models.HomestayService;
import com.sbhs.swm.repositories.BookingRepo;
import com.sbhs.swm.repositories.HomestayRepo;
import com.sbhs.swm.services.IFilterHomestayService;
import com.sbhs.swm.services.IGoongService;
import com.sbhs.swm.util.BookingDateValidationString;
import com.sbhs.swm.util.BookingDateValidationUtil;
import com.sbhs.swm.util.DateFormatUtil;

@Service
public class FilterHomestayService implements IFilterHomestayService {

    @Autowired
    private BookingRepo bookingRepo;

    @Autowired
    private HomestayRepo homestayRepo;

    @Autowired
    private BookingDateValidationUtil bookingDateValidationUtil;

    @Autowired
    private DateFormatUtil dateFormatUtil;

    @Autowired
    private IGoongService goongService;

    @Override
    public List<Homestay> filterByRatingRange(List<Homestay> homestays, double highest, double lowest) {
        homestays = homestays.stream()
                .filter(h -> h.getTotalAverageRating() <= highest && h.getTotalAverageRating() >= lowest)
                .collect(Collectors.toList());
        return homestays;
    }

    @Override
    public List<Homestay> filterByBookingDateRange(List<Homestay> homestays, String bookingStart, String bookingEnd,
            int totalBookingRoom) {
        List<Homestay> homestaySortedList = homestays.stream()
                .filter(h -> this.checkValidBooking(h, bookingStart, bookingEnd, totalBookingRoom))
                .collect(Collectors.toList());
        return homestaySortedList;
    }

    private boolean checkValidBooking(Homestay homestay, String bookingStart, String bookingEnd, int totalRoom) {
        int totalBookedRoom = bookingRepo.totalHomestayRoomBooked(homestay.getName()) != null
                ? bookingRepo.totalHomestayRoomBooked(homestay.getName())
                : 0;
        int availableRoom = homestay.getAvailableRooms() - totalBookedRoom;
        String getBookingValidationgString = bookingDateValidationUtil.bookingValidateString(bookingStart, bookingEnd,
                homestay.getName());
        switch (BookingDateValidationString.valueOf(getBookingValidationgString)) {
            case INVALID:
                return false;
            case CURRENT_END_ON_BOOKED_END:

                if (availableRoom == 0 || totalRoom > availableRoom) {
                    return false;
                }
                return true;
            case CURRENT_START_ON_BOOKED_END:
                int totalRoomWillBeFreed = 0;
                for (Booking b : homestay.getBookings()) {
                    Date bookedEnd = dateFormatUtil.formatGivenDate(b.getBookingTo());
                    Date currentStart = dateFormatUtil.formatGivenDate(bookingStart);
                    if (bookedEnd.before(currentStart) || bookedEnd.compareTo(currentStart) == 0) {
                        int totalFreeRoomOnDate = bookingRepo.totalHomestayRoomWillBeCheckedOut(homestay.getName(),
                                b.getBookingTo()) != null
                                        ? bookingRepo.totalHomestayRoomWillBeCheckedOut(homestay.getName(),
                                                b.getBookingTo())
                                        : 0;
                        totalRoomWillBeFreed = totalRoomWillBeFreed + totalFreeRoomOnDate;
                    }
                }
                availableRoom = availableRoom + totalRoomWillBeFreed;
                if (availableRoom == 0 || totalRoom > availableRoom) {
                    return false;
                }
                return true;
            case CURRENT_START_ON_BOOKED_START:
                if (availableRoom == 0 || totalRoom > availableRoom) {
                    return false;
                }
                return true;
            case ON_BOOKING_PERIOD:
                if (availableRoom == 0 || totalRoom > availableRoom) {
                    return false;
                }
                return true;
            case OK:
                if (totalRoom > availableRoom) {
                    return false;
                }
                return true;
        }
        return false;
    }

    @Override
    public List<Homestay> filterByAddress(List<Homestay> homestays, String address, int distance,
            boolean isGeometry) {
        List<String> destinations = homestays.stream().map(h -> h.getAddress())
                .collect(Collectors.toList());
        DistanceResultRows distanceResultRows = goongService.getDistanceFromLocation(address, destinations, isGeometry);
        List<DistanceElement> distanceElements = distanceResultRows.getRows().get(0).getElements().stream()
                .filter(e -> e.getDistance().getValue() <= distance).collect(Collectors.toList());
        homestays = distanceElements.stream().map(d -> homestayRepo.findHomestayByAddress(d.getAddress()).get())
                .collect(Collectors.toList());
        return homestays;

    }

    @Override
    public List<Homestay> filterByPriceRange(List<Homestay> homestays, long highest, long lowest) {
        homestays = homestays.stream().filter(h -> h.getPrice() <= highest && h.getPrice() >= lowest)
                .collect(Collectors.toList());
        return homestays;
    }

    @Override
    public List<Homestay> filterByFacility(List<Homestay> homestays, String name, int quantity) {
        homestays = homestays.stream().filter(h -> {
            for (HomestayFacility f : h.getHomestayFacilities()) {
                return f.getName().equalsIgnoreCase(name) && f.getQuantity() >= quantity;
            }
            return false;
        }).collect(Collectors.toList());
        return homestays;
    }

    @Override
    public List<Homestay> filterByHomestayService(List<Homestay> homestays, String name, long price) {
        homestays = homestays.stream().filter(h -> {
            for (HomestayService s : h.getHomestayServices()) {
                return s.getName().equalsIgnoreCase(name) && s.getPrice() == price;
            }
            return false;
        }).collect(Collectors.toList());

        return homestays;
    }

}
