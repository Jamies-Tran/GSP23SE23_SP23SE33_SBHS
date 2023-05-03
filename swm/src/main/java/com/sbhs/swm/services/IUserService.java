package com.sbhs.swm.services;

import java.util.List;

import org.springframework.beans.support.PagedListHolder;

import com.sbhs.swm.models.BookingDeposit;
import com.sbhs.swm.models.LandlordCommission;
import com.sbhs.swm.models.PasswordModificationOtp;
import com.sbhs.swm.models.SwmUser;

public interface IUserService {
    public SwmUser findUserByUsername(String username);

    public SwmUser authenticatedUser();

    public SwmUser registerPassengerAccount(SwmUser user);

    public SwmUser registerLandlordAccount(SwmUser user, String idCardFrontImageUrl, String idCardBackImageUrl);

    public SwmUser login(String username, String password);

    public SwmUser loginByGoogle(String email);

    public boolean validateEmail(String email);

    public void sendPasswordModificationOtpMail(String email);

    public PasswordModificationOtp savePasswordModificationOtp(String otp, String email);

    public void verifyPasswordModificationByOtp(String otp);

    public void changePassword(String newPassword, String email);

    public void deletePasswordOtp(String otp);

    public Long getUserActualBalance(String role, SwmUser user);

    public PagedListHolder<BookingDeposit> getUserBookingDeposit(int page, int size, boolean isNextPage,
            boolean isPreviousPage);

    public List<LandlordCommission> getLandlordCommissionList();
}
