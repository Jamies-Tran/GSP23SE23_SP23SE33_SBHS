package com.sbhs.swm.services;

import java.util.List;

import com.sbhs.swm.models.BlocHomestay;

public interface IFilterBlocHomestayService {
    public List<BlocHomestay> filterByRatingRange(List<BlocHomestay> blocs, double lowest, double highest);

    public List<BlocHomestay> filterBlocByBookingDateRange(List<BlocHomestay> blocs, String bookingStart,
            String bookingEnd, int totalBookingRoom);

    public List<BlocHomestay> filterByAddress(List<BlocHomestay> blocs, String address, int distance,
            boolean isGeometry);

    public List<BlocHomestay> filterByPriceRange(List<BlocHomestay> blocs, long lowest, long heighest);

    public List<BlocHomestay> filterByFacility(List<BlocHomestay> blocs, String name, int quantity);

    public List<BlocHomestay> filterByBlocService(List<BlocHomestay> blocs, String name, long price);
}
