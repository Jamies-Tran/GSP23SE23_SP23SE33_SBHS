package com.sbhs.swm.services;

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
}
