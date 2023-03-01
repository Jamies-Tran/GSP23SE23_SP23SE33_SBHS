package com.sbhs.swm.services;

import java.util.List;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.data.domain.Page;

import com.sbhs.swm.models.BlocHomestay;
import com.sbhs.swm.models.Homestay;

public interface IHomestayService {
        public Homestay createHomestay(Homestay homestay);

        public BlocHomestay createBlocHomestay(BlocHomestay blocHomestay);

        public Homestay findHomestayByName(String name);

        public BlocHomestay findBlocHomestayByName(String name);

        public Homestay findHomestayByAddress(String address);

        public Page<Homestay> findHomestayList(String filter, String name, int page, int size, boolean isNextPage,
                        boolean isPreviousPage);

        public Page<BlocHomestay> findBlocHomestaysByStatus(String status, int page, int size, boolean isNextPage,
                        boolean isPreviousPage);

        public List<String> getHomestayCityOrProvince();

        public Integer getTotalHomestayOnLocation(String location);

        public List<String> getBlocCityOrProvince();

        public Integer getTotalBlocOnLocation(String location);

        public Page<Homestay> getHomestayListOrderByTotalAverageRatingPoint(int page, int size, boolean isNextPage,
                        boolean isPreviousPage);

        public Page<BlocHomestay> getBlocListOrderByTotalAverageRatingPoint(int page, int size, boolean isNextPage,
                        boolean isPreviousPage);

        public PagedListHolder<Homestay> getHomestayListNearByLocation(String address, int page, int size,
                        boolean isNextPage,
                        boolean isPreviousPage,
                        boolean isGeometry);
}
