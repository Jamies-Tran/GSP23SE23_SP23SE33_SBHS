package com.sbhs.swm.repositories;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.sbhs.swm.models.SwmUser;

public interface UserRepo extends JpaRepository<SwmUser, Long> {

    @Query(value = "select u from SwmUser u where u.username = :username")
    Optional<SwmUser> findByUsername(@Param("username") String username);

    @Query(value = "select u from SwmUser u where u.email = :email")
    Optional<SwmUser> findByEmail(@Param("email") String email);

    @Query(value = "select u from SwmUser u where u.phone = :phone")
    Optional<SwmUser> findByPhone(@Param("phone") String phone);

}
