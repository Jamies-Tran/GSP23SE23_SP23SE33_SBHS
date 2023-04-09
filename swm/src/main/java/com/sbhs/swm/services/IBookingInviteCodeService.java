package com.sbhs.swm.services;

import com.sbhs.swm.models.BookingInviteCode;

public interface IBookingInviteCodeService {
    BookingInviteCode getBookingInviteCodeByCode(String inviteCode);

    BookingInviteCode applyBookingInviteCode(String inviteCode);
}
