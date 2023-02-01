package com.sbhs.swm.implement;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sbhs.swm.handlers.exceptions.RoleNotFoundException;
import com.sbhs.swm.models.SwmRole;
import com.sbhs.swm.repositories.RoleRepo;
import com.sbhs.swm.services.IRoleService;

@Service
public class RoleService implements IRoleService {

    @Autowired
    private RoleRepo roleRepo;

    @Override
    public SwmRole findRoleById(long id) {
        return roleRepo.findById(id).orElseThrow();
    }

    @Override
    public SwmRole findRoleByName(String name) {
        SwmRole role = roleRepo.findByName(name).orElseThrow(() -> new RoleNotFoundException());
        return role;
    }

}
