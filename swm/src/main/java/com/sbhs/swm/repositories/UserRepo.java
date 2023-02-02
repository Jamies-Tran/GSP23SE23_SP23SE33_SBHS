package com.sbhs.swm.repositories;

import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.sbhs.swm.models.SwmUser;

public interface UserRepo extends JpaRepository<SwmUser, Long> {

    @Query(value = "select u from SwmUser u where u.username = :username")
    Optional<SwmUser> findByUsername(@Param("username") String username);

    @Query(value = "select u from SwmUser u where u.landlordProperty != null and u.username = :username")
    Optional<SwmUser> findLandlordByUsername(@Param("username") String username);

    @Query(value = "select u from SwmUser u where u.email = :email")
    Optional<SwmUser> findByEmail(@Param("email") String email);

    @Query(value = "select u from SwmUser u where u.phone = :phone")
    Optional<SwmUser> findByPhone(@Param("phone") String phone);

    @Query(value = "select u from SwmUser u where u.landlordProperty.status = :status")
    Page<SwmUser> findLandlordListFilterByStatus(Pageable pageable, @Param("status") String status);
}
