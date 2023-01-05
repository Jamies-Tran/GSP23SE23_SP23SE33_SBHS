package com.sbhs.swm.services;

import com.sbhs.swm.models.SwmUser;

public interface IUserService {
    public SwmUser findUserByUsername(String username);

    // public void registerPassengerAccount();
}
