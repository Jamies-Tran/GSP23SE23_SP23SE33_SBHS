package com.sbhs.swm.services;

import org.springframework.lang.Nullable;

import com.sbhs.swm.models.BlocHomestay;
import com.sbhs.swm.models.Booking;
import com.sbhs.swm.models.BookingHomestay;
import com.sbhs.swm.models.BookingInviteCode;
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

    public void lowBalanceInformToLandlord(String username);

    public void informBookingSharedCodeHadBeenApplied(BookingInviteCode bookingShareCode);

    public void informBookingForHomestayAccepted(BookingHomestay bookingHomestay);

    public void informBookingForHomestayRejected(BookingHomestay bookingHomestay, String message);

    public void informBookingForBlocAccepted(Booking booking);

    public void informBookingForBlocRejected(Booking booking, String message);
}
