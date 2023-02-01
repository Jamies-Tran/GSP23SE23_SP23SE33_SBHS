package com.sbhs.swm.services;

import com.sbhs.swm.models.SwmRole;

public interface IRoleService {
    public SwmRole findRoleById(long id);

    public SwmRole findRoleByName(String name);
}
