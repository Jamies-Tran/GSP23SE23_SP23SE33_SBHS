package com.sbhs.swm.services;

import java.util.List;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.data.domain.Page;

import com.sbhs.swm.dto.request.FilterOption;
import com.sbhs.swm.models.BlocHomestay;
import com.sbhs.swm.models.Homestay;

public interface IHomestayService {
        public Homestay createHomestay(Homestay homestay);

        public BlocHomestay createBlocHomestay(BlocHomestay blocHomestay);

        public Homestay findHomestayByName(String name);

        public BlocHomestay findBlocHomestayByName(String name);

        public Homestay findHomestayByAddress(String address);

        public PagedListHolder<Homestay> findHomestayList(String filterBy, int page, int size,
                        boolean isNextPage,
                        boolean isPreviousPage);

        public PagedListHolder<BlocHomestay> findBlocList(String filterBy, int page, int size,
                        boolean isNextPage,
                        boolean isPreviousPage);

        public PagedListHolder<BlocHomestay> findBlocHomestaysByStatus(String status, int page, int size,
                        boolean isNextPage,
                        boolean isPreviousPage);

        public PagedListHolder<Homestay> findHomestaysByStatus(String status, int page, int size,
                        boolean isNextPage,
                        boolean isPreviousPage);

        public List<String> getHomestayCityOrProvince();

        public Integer getTotalHomestayOnLocation(String location);

        public List<String> getBlocCityOrProvince();

        public Integer getTotalBlocOnLocation(String location);

        public Page<Homestay> getHomestayListOrderByTotalAverageRatingPoint(int page, int size, boolean isNextPage,
                        boolean isPreviousPage);

        public Page<BlocHomestay> getBlocListOrderByTotalAverageRatingPoint(int page, int size, boolean isNextPage,
                        boolean isPreviousPage);

        public PagedListHolder<Homestay> getHomestayListFiltered(FilterOption filterOption, String searchString,
                        int page, int size,
                        boolean isNextPage,
                        boolean isPreviousPage);

        public PagedListHolder<BlocHomestay> getBlocListFiltered(FilterOption filterOption, String searchString,
                        int page, int size,
                        boolean isNextPage, boolean isPreviousPage);

        public Integer getHomestayNumberOfReview(String homestayName);

        public Integer getBlocHomestayNumberOfReview(String blocName);

        // public List<Homestay> filterByAddress(List<Homestay> homestays, String
        // address, boolean isGeometry);

        public List<String> getAllHomestayFacilityNames(String homestayType);

        public List<String> getAllHomestayServiceNames(String homestayType);

        public Long getHighestPriceOfHomestayService(String homestayType);

        public Long getHighestPriceOfHomestay(String homestayType);
}
