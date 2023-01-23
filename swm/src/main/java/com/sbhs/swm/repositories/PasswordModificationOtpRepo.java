package com.sbhs.swm.repositories;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.sbhs.swm.models.PasswordModificationOtp;

public interface PasswordModificationOtpRepo extends JpaRepository<PasswordModificationOtp, Long> {
    @Query(value = "select otp from PasswordModificationOtp otp where otp.otpToken = :otpToken")
    Optional<PasswordModificationOtp> findOtpByCode(@Param("otpToken") String otp);
}
