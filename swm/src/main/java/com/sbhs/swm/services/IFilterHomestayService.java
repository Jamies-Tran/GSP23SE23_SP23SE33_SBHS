package com.sbhs.swm.services;

import java.util.List;

import com.sbhs.swm.models.Homestay;

public interface IFilterHomestayService {
        public List<Homestay> filterByRatingRange(List<Homestay> homestays, double highest, double lowest);

        public List<Homestay> filterByBookingDateRange(List<Homestay> homestays, String bookingStart, String bookingEnd,
                        int totalBookingRoom);

        public List<Homestay> filterByAddress(List<Homestay> homestays, String address, int distance,
                        boolean isGeometry);

        public List<Homestay> filterByPriceRange(List<Homestay> homestays, long highest, long lowest);

        public List<Homestay> filterByFacility(List<Homestay> homestays, String name, int quantity);

        public List<Homestay> filterByHomestayService(List<Homestay> homestays, String name, long price);

        public List<Homestay> filterBySearchString(List<Homestay> homestays, String searchString);
}
