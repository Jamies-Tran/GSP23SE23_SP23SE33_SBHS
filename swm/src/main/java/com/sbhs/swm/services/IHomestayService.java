package com.sbhs.swm.services;

import org.springframework.data.domain.Page;

import com.sbhs.swm.models.BlocHomestay;
import com.sbhs.swm.models.Homestay;

public interface IHomestayService {
    public Homestay createHomestay(Homestay homestay);

    public BlocHomestay createBlocHomestay(BlocHomestay blocHomestay);

    public Homestay findHomestayByName(String name);

    public Page<Homestay> findHomestayList(String filter, String param, int page, int size, boolean isNextPage,
            boolean isPreviousPage);

}
