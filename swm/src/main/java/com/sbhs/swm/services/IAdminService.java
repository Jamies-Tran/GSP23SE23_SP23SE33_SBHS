package com.sbhs.swm.services;

import org.springframework.data.domain.Page;

import com.sbhs.swm.models.Homestay;
import com.sbhs.swm.models.SwmUser;

public interface IAdminService {
    public SwmUser createFirstAdminAccount();

    public SwmUser createAdminAccount(SwmUser user);

    public Page<SwmUser> findLandlordListFilterByStatus(String status, int page, int size, boolean isNextPage,
            boolean isPreviousPage);

    public SwmUser activateLandlordAccount(String username);

    public Homestay activateHomestay(String name);
}
