package com.sbhs.swm.implement;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sbhs.swm.handlers.exceptions.InvalidException;
import com.sbhs.swm.handlers.exceptions.NotFoundException;
import com.sbhs.swm.models.Booking;
import com.sbhs.swm.models.BookingInviteCode;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.models.status.BookingInviteCodeStatus;
import com.sbhs.swm.models.status.BookingStatus;
import com.sbhs.swm.repositories.BookingInviteCodeRepo;
import com.sbhs.swm.services.IBookingInviteCodeService;
import com.sbhs.swm.services.IMailService;
import com.sbhs.swm.services.IUserService;

@Service
public class BookingInviteCodeService implements IBookingInviteCodeService {

    @Autowired
    private IUserService userService;

    @Autowired
    private IMailService mailService;

    @Autowired
    private BookingInviteCodeRepo bookingShareCodeRepo;

    // @Autowired
    // private DateTimeUtil dateTimeUtil;

    @Override
    public BookingInviteCode getBookingInviteCodeByCode(String inviteCode) {
        BookingInviteCode bookingShareCode = bookingShareCodeRepo.findBookingInviteCodeByCode(inviteCode)
                .orElseThrow(() -> new NotFoundException("Share code not exist"));

        return bookingShareCode;
    }

    @Override
    @Transactional
    public BookingInviteCode applyBookingInviteCode(String inviteCode) {
        SwmUser user = userService.authenticatedUser();
        BookingInviteCode bookingInviteCode = getBookingInviteCodeByCode(inviteCode);

        if (bookingInviteCode.getCreatedBy().equals(user.getUsername())) {
            throw new InvalidException("You can't apply invite code of your own");
        }
        Booking booking = bookingInviteCode.getBooking();
        if (booking.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name())
                || booking.getStatus().equalsIgnoreCase(BookingStatus.PENDING.name())
                || booking.getStatus().equalsIgnoreCase(BookingStatus.REJECTED.name())
                || booking.getStatus().equalsIgnoreCase(BookingStatus.CHECKEDOUT.name())) {
            throw new InvalidException("Booking's not valid");
        }
        List<BookingInviteCode> currentBookingInviteCodeList = user.getPassengerProperty().getInviteCodes();
        currentBookingInviteCodeList.add(bookingInviteCode);
        bookingInviteCode.setPassengers(List.of(user.getPassengerProperty()));
        bookingInviteCode.setStatus(BookingInviteCodeStatus.USED.name());
        user.getPassengerProperty().setInviteCodes(currentBookingInviteCodeList);
        mailService.informBookingSharedCodeHadBeenApplied(bookingInviteCode, user.getUsername());

        return bookingInviteCode;
    }

}
