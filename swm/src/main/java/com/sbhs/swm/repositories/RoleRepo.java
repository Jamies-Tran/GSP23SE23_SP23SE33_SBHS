package com.sbhs.swm.repositories;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.sbhs.swm.models.SwmRole;

public interface RoleRepo extends JpaRepository<SwmRole, Long> {
    @Query(value = "select r from SwmRole r where r.name = :name")
    Optional<SwmRole> findByName(@Param("name") String name);
}
