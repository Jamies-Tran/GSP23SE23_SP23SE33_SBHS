package com.sbhs.swm.services;

import java.util.List;

import com.sbhs.swm.models.SwmUser;

public interface IAdminService {
    public SwmUser createFirstAdminAccount();

    public SwmUser createAdminAccount(SwmUser user);

    public List<SwmUser> findLandlordListFilterByStatus(String status, int page, int size);

    public SwmUser activateLandlordAccount(String username);
}
