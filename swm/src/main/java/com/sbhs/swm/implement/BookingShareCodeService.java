package com.sbhs.swm.implement;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sbhs.swm.handlers.exceptions.InvalidException;
import com.sbhs.swm.handlers.exceptions.NotFoundException;
import com.sbhs.swm.models.Booking;
import com.sbhs.swm.models.BookingDeposit;
import com.sbhs.swm.models.BookingShareCode;
import com.sbhs.swm.models.Deposit;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.models.status.BookingShareCodeStatus;
import com.sbhs.swm.models.status.BookingStatus;
import com.sbhs.swm.models.type.HomestayType;
import com.sbhs.swm.repositories.BookingShareCodeRepo;
import com.sbhs.swm.repositories.DepositRepo;
import com.sbhs.swm.services.IBookingShareCodeService;
import com.sbhs.swm.services.IMailService;
import com.sbhs.swm.services.IUserService;
import com.sbhs.swm.util.DateTimeUtil;

@Service
public class BookingShareCodeService implements IBookingShareCodeService {

    @Autowired
    private IUserService userService;

    @Autowired
    private IMailService mailService;

    @Autowired
    private BookingShareCodeRepo bookingShareCodeRepo;

    @Autowired
    private DepositRepo depositRepo;

    @Autowired
    private DateTimeUtil dateTimeUtil;

    @Override
    public BookingShareCode getBookingSharedCodeByCode(String shareCode) {
        BookingShareCode bookingShareCode = bookingShareCodeRepo.findBookingShareCodeByCode(shareCode)
                .orElseThrow(() -> new NotFoundException("Share code not exist"));

        return bookingShareCode;
    }

    @Override
    @Transactional
    public BookingShareCode applyBookingShareCode(String shareCode) {
        SwmUser user = userService.authenticatedUser();
        BookingShareCode bookingShareCode = getBookingSharedCodeByCode(shareCode);

        if (bookingShareCode.getCreatedBy().equals(user.getUsername())) {
            throw new InvalidException("You can't apply share code of your own");
        }
        Booking booking = bookingShareCode.getBooking();
        if (!booking.getStatus().equalsIgnoreCase(BookingStatus.ACCEPTED.name())) {
            throw new InvalidException("Booking's not valid");
        }
        if (booking.getBookingDeposits() != null) {
            for (BookingDeposit d : booking.getBookingDeposits()) {
                Long currentDepositUnpaidAmount = d.getUnpaidAmount();
                Long guestDepositSharedAmount = (currentDepositUnpaidAmount * 50) / 100;
                if (user.getPassengerProperty().getBalanceWallet().getTotalBalance() < guestDepositSharedAmount) {
                    throw new InvalidException("Your balance is not enough to share this booking");
                }
                Long hostDepositRemainAmount = currentDepositUnpaidAmount - guestDepositSharedAmount;
                d.setUnpaidAmount(hostDepositRemainAmount);
                BookingDeposit bookingDeposit = new BookingDeposit();
                bookingDeposit.setPaidAmount(0L);
                bookingDeposit.setUnpaidAmount(guestDepositSharedAmount);
                bookingDeposit.setBooking(booking);
                switch (HomestayType.valueOf(booking.getHomestayType().toUpperCase())) {
                    case HOMESTAY:
                        bookingDeposit.setDepositForHomestay(d.getDepositForHomestay());
                        break;
                    case BLOC:
                        bookingDeposit.setDepositForHomestay(d.getBooking().getBloc().getName());
                        break;
                }
                Deposit deposit = new Deposit();
                deposit.setCreatedBy(user.getUsername());
                deposit.setCreatedDate(dateTimeUtil.formatDateTimeNowToString());
                deposit.setPassengerWallet(user.getPassengerProperty().getBalanceWallet().getPassengerWallet());
                deposit.setBookingDeposits(List.of(bookingDeposit));
                bookingDeposit.setDeposit(deposit);
                bookingDeposit.setBooking(booking);
                booking.setBookingDeposits(List.of(bookingDeposit));
                depositRepo.save(deposit);
            }
        }
        bookingShareCode.setPassenger(user.getPassengerProperty());
        bookingShareCode.setStatus(BookingShareCodeStatus.USED.name());
        user.getPassengerProperty().setShareCode(bookingShareCode);
        mailService.informBookingSharedCodeHadBeenApplied(bookingShareCode);

        return bookingShareCode;
    }

}
