package com.sbhs.swm.implement;

import java.io.UnsupportedEncodingException;

import javax.mail.MessagingException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.lang.Nullable;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.sbhs.swm.models.BlocHomestay;
import com.sbhs.swm.models.BookingHomestay;
import com.sbhs.swm.models.BookingShareCode;
import com.sbhs.swm.models.Homestay;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.services.IMailService;
import com.sbhs.swm.services.IUserService;
import com.sbhs.swm.util.GenerateMailContentUtil;

@Service
public class MailService implements IMailService {

    private String HOMESTAY = "HOMESTAY";

    private String BLOC_HOMESTAY = "BLOC";

    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    @Lazy
    private IUserService userService;

    @Override
    public void userChangePasswordOtpMailSender(String email) {
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage);
        String otp = GenerateMailContentUtil.passwordModificationOtpGenerator();
        try {
            helper.setTo(new InternetAddress(email));
            helper.setFrom("no-reply@swm.com", "stay_with_me");
            helper.setSubject("Change password");
            helper.setText(GenerateMailContentUtil.generatePassengerChangePasswordOtpMailSubject(otp), true);
            mailSender.send(mimeMessage);
            userService
                    .savePasswordModificationOtp(otp, email);
        } catch (MessagingException | UnsupportedEncodingException e) {
            throw new RuntimeException(e.getMessage());
        }
    }

    @Override
    public void approveLandlordAccount(SwmUser user) {
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage);
        try {
            helper.setTo(new InternetAddress(user.getEmail()));
            helper.setFrom("no-reply@swm.com", "stay_with_me");
            helper.setSubject("Landlord account");
            helper.setText(GenerateMailContentUtil.generateLandlordApprovedMailSubject(user.getUsername()), true);
            mailSender.send(mimeMessage);
        } catch (MessagingException | UnsupportedEncodingException e) {
            throw new RuntimeException(e.getMessage());
        }

    }

    @Override
    public void rejectLandlordAccount(SwmUser user) {
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage);
        try {
            helper.setTo(new InternetAddress(user.getEmail()));
            helper.setFrom("no-reply@swm.com", "stay_with_me");
            helper.setSubject("Landlord account");
            helper.setText(
                    GenerateMailContentUtil.generateLandlordRejectedMailSubject(user.getUsername(),
                            user.getLandlordProperty().getStatus()),
                    true);
            mailSender.send(mimeMessage);
        } catch (MessagingException | UnsupportedEncodingException e) {
            throw new RuntimeException(e.getMessage());
        }

    }

    @Override
    public void approveHomestay(@Nullable Homestay homestay, @Nullable BlocHomestay bloc) {
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage);
        try {
            if (homestay != null && bloc == null) {
                helper.setTo(new InternetAddress(homestay.getLandlord().getUser().getEmail()));
                helper.setText(
                        GenerateMailContentUtil.generateApproveHomestayMailSubject(homestay.getName(), this.HOMESTAY),
                        true);
            } else if (bloc != null && homestay == null) {
                helper.setTo(new InternetAddress(bloc.getLandlord().getUser().getEmail()));
                helper.setText(
                        GenerateMailContentUtil.generateApproveHomestayMailSubject(bloc.getName(), this.BLOC_HOMESTAY),
                        true);
            }
            helper.setFrom("no-reply@swm.com", "stay_with_me");
            helper.setSubject("Homestay pending");
            mailSender.send(mimeMessage);
        } catch (MessagingException | UnsupportedEncodingException e) {
            throw new RuntimeException(e.getMessage());
        }
    }

    @Override
    public void rejectHomestay(Homestay homestay, BlocHomestay bloc) {
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage);
        try {
            if (homestay != null && bloc == null) {
                helper.setTo(new InternetAddress(homestay.getLandlord().getUser().getEmail()));
                helper.setText(
                        GenerateMailContentUtil.generateRejectHomestayMailSubject(homestay.getName(), this.HOMESTAY),
                        true);
            } else if (bloc != null && homestay == null) {
                helper.setTo(new InternetAddress(bloc.getLandlord().getUser().getEmail()));
                helper.setText(
                        GenerateMailContentUtil.generateRejectHomestayMailSubject(bloc.getName(), this.BLOC_HOMESTAY),
                        true);
            }
            helper.setFrom("no-reply@swm.com", "stay_with_me");
            helper.setSubject("Homestay pending");
            mailSender.send(mimeMessage);
        } catch (MessagingException | UnsupportedEncodingException e) {
            throw new RuntimeException(e.getMessage());
        }
    }

    @Override
    public void informBookingToLandlord(String landlordName, String passengerName, String createdDate,
            String landlordMail, String homestayType,
            Integer numberOfHomestayBooked, String blocName) {

        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage);
        try {
            helper.setTo(new InternetAddress(landlordMail));
            helper.setFrom("no-reply@swm.com", "stay_with_me");
            helper.setSubject("New booking");
            helper.setText(
                    GenerateMailContentUtil.generateInformBookingMailSubject(landlordName, passengerName, createdDate,
                            homestayType,
                            numberOfHomestayBooked, blocName),
                    true);
            mailSender.send(mimeMessage);

        } catch (MessagingException | UnsupportedEncodingException e) {
            throw new RuntimeException(e.getMessage());
        }
    }

    @Override
    public void lowBalanceInformToLandlord(String username) {
        SwmUser user = userService.findUserByUsername(username);

        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage);
        try {
            helper.setTo(new InternetAddress(user.getEmail()));
            helper.setFrom("no-reply@swm.com", "stay_with_me");
            helper.setSubject("Low balance");
            helper.setText(GenerateMailContentUtil.generateLowBalanceInformLandlordMailSubject(username), true);
        } catch (MessagingException | UnsupportedEncodingException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void informBookingSharedCodeHadBeenApplied(BookingShareCode bookingShareCode) {
        String ingformShareCodeInformMail = GenerateMailContentUtil
                .generateInformBookingSharedCodeHadBeenApplied(bookingShareCode);
        SwmUser bookingHost = bookingShareCode.getBooking().getPassenger().getUser();
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage);
        try {
            helper.setTo(new InternetAddress(bookingHost.getEmail()));
            helper.setText(
                    ingformShareCodeInformMail,
                    true);
            helper.setFrom("no-reply@swm.com", "stay_with_me");
            helper.setSubject("Booking Invite");
            mailSender.send(mimeMessage);
        } catch (MessagingException | UnsupportedEncodingException e) {
            throw new RuntimeException(e.getMessage());
        }
    }

    @Override
    public void informBookingForHomestayAccepted(BookingHomestay bookingHomestay) {
        String ingformShareCodeInformMail = GenerateMailContentUtil
                .generateInformAcceptBookingForHomestay(bookingHomestay);
        SwmUser bookingHost = bookingHomestay.getBooking().getPassenger().getUser();
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage);
        try {
            helper.setTo(new InternetAddress(bookingHost.getEmail()));
            helper.setText(
                    ingformShareCodeInformMail,
                    true);
            helper.setFrom("no-reply@swm.com", "stay_with_me");
            helper.setSubject("Booking Accepted");
            mailSender.send(mimeMessage);
        } catch (MessagingException | UnsupportedEncodingException e) {
            throw new RuntimeException(e.getMessage());
        }
    }

    @Override
    public void informBookingForHomestayRejected(BookingHomestay bookingHomestay, String message) {
        String ingformShareCodeInformMail = GenerateMailContentUtil
                .generateInformRejectBookingForHomestay(bookingHomestay, message);
        SwmUser bookingHost = bookingHomestay.getBooking().getPassenger().getUser();
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage);
        try {
            helper.setTo(new InternetAddress(bookingHost.getEmail()));
            helper.setText(
                    ingformShareCodeInformMail,
                    true);
            helper.setFrom("no-reply@swm.com", "stay_with_me");
            helper.setSubject("Booking Rejected");
            mailSender.send(mimeMessage);
        } catch (MessagingException | UnsupportedEncodingException e) {
            throw new RuntimeException(e.getMessage());
        }
    }
}
