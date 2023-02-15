package com.sbhs.swm.services;

import com.sbhs.swm.models.BlocHomestay;
import com.sbhs.swm.models.Homestay;

public interface IHomestayService {
    public Homestay createHomestay(Homestay homestay);

    public BlocHomestay createBlocHomestay(BlocHomestay blocHomestay);
}
