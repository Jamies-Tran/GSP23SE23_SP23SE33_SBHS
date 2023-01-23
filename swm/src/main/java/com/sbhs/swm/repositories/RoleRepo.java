package com.sbhs.swm.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.sbhs.swm.models.SwmRole;

public interface RoleRepo extends JpaRepository<SwmRole, Long> {

}
