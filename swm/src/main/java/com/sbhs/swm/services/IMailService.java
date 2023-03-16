package com.sbhs.swm.services;

import org.springframework.lang.Nullable;

import com.sbhs.swm.models.BlocHomestay;
import com.sbhs.swm.models.Homestay;
import com.sbhs.swm.models.SwmUser;

public interface IMailService {
    public void userChangePasswordOtpMailSender(String email);

    public void approveLandlordAccount(SwmUser user);

    public void rejectLandlordAccount(SwmUser user);

    public void approveHomestay(@Nullable Homestay homestay, @Nullable BlocHomestay bloc);

    public void rejectHomestay(@Nullable Homestay homestay, @Nullable BlocHomestay bloc);

    public void informBookingToLandlord(String landlordName, String passengerName,
            String createdDate, String landlordMail, String homestayType, @Nullable Integer numberOfHomestayBooked,
            @Nullable String blocName);
}
