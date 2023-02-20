package com.sbhs.swm.services;

import org.springframework.data.domain.Page;

import com.sbhs.swm.models.BlocHomestay;
import com.sbhs.swm.models.Homestay;
import com.sbhs.swm.models.SwmUser;

public interface IAdminService {
    public SwmUser createFirstAdminAccount();

    public SwmUser createAdminAccount(SwmUser user);

    public Page<SwmUser> findLandlordListFilterByStatus(String status, int page, int size, boolean isNextPage,
            boolean isPreviousPage);

    public SwmUser activateLandlordAccount(String username);

    public SwmUser rejectLandlordAccount(String username, String reason);

    public Homestay activateHomestay(String name);

    public BlocHomestay activateBlocHomestay(String name);

    public Homestay rejectHomestay(String name);

    public BlocHomestay rejectBloc(String name);
}
