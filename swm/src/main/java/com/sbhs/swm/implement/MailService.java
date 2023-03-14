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
import com.sbhs.swm.models.Booking;
import com.sbhs.swm.models.Homestay;
import com.sbhs.swm.models.Landlord;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.models.status.LandlordStatus;
import com.sbhs.swm.services.IMailService;
import com.sbhs.swm.services.IUserService;

import net.bytebuddy.utility.RandomString;

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
        String otp = passwordModificationOtpGenerator();
        try {
            helper.setTo(new InternetAddress(email));
            helper.setFrom("no-reply@swm.com", "stay_with_me");
            helper.setSubject("Change password");
            helper.setText(generatePassengerChangePasswordOtpMailSubject(otp), true);
            mailSender.send(mimeMessage);
            userService
                    .savePasswordModificationOtp(otp, email);
        } catch (MessagingException | UnsupportedEncodingException e) {
            throw new RuntimeException(e.getMessage());
        }
    }

    private String generatePassengerChangePasswordOtpMailSubject(String otp) {
        StringBuilder builder = new StringBuilder();
        builder.append(
                "<center><p style=\"letter-spacing:1.0;font-family:courier;\">Here is your otp code:</p></center></br><center><h1>")
                .append(otp).append("</h1></center>");
        return builder.toString();
    }

    private String generateLandlordApprovedMailSubject(String username) {
        StringBuilder builder = new StringBuilder();
        builder.append("<h1>You are now a partner of Stay With Me</h1>").append("</br>").append(
                "<p>Your account <span style=\"font-weight:bold;color:orange\">").append(username)
                .append("</span> had been approved and now can access our <a href=\"https://www.google.com/\">website</a></p>")
                .append("</br>").append("<p>We're look forward to working with you soon.</p>").append("</br>")
                .append("<p>Sinerely</p>").append("</br>").append("<h2>Stay With Me</h2>");
        return builder.toString();
    }

    private String generateApproveHomestayMailSubject(String name, String style) {
        StringBuilder builder = new StringBuilder();
        switch (style) {
            case "HOMESTAY":
                builder.append("<h1>Your homestay is ready to go</h1>").append("</br>").append(
                        "<p>Your homestay <span style=\"font-weight:bold;color:orange\">").append(name)
                        .append("</span> had been approved and now available on our system</p>")
                        .append("</br>").append("<p>Be ready for passenger can book your homestay anytime.</p>")
                        .append("</br>")
                        .append("<p>Sinerely</p>").append("</br>").append("<h2>Stay With Me</h2>");
                break;
            case "BLOC":
                builder.append("<h1>Your bloc is ready to go</h1>").append("</br>").append(
                        "<p>Your bloc <span style=\"font-weight:bold;color:orange\">").append(name)
                        .append("</span> had been approved and now available on our system</p>")
                        .append("</br>").append("<p>Be ready for passenger can book your bloc anytime.</p>")
                        .append("</br>")
                        .append("<p>Sinerely</p>").append("</br>").append("<h2>Stay With Me</h2>");
        }
        return builder.toString();
    }

    private String generateRejectHomestayMailSubject(String name, String style) {
        StringBuilder builder = new StringBuilder();
        switch (style) {
            case "HOMESTAY":
                builder.append("<h1>Your homestay had been rejected</h1>").append("</br>").append(
                        "<p>Your homestay <span style=\"font-weight:bold;color:orange\">").append(name)
                        .append("</span> had been rejected due to invalid license you'd provided</p>")
                        .append("</br>")
                        .append("Please contact us via phone 0981874736 or admin001@gmail.com for more information.")
                        .append("</br>")
                        .append("<p>Sinerely</p>").append("</br>").append("<h2>Stay With Me</h2>");
                break;
            case "BLOC":
                builder.append("<h1>Your bloc had been rejected</h1>").append("</br>").append(
                        "<p>Your bloc <span style=\"font-weight:bold;color:orange\">").append(name)
                        .append("</span> had been rejected due to invalid license you'd provided</p>")
                        .append("</br>")
                        .append("Please contact us via phone 0981874736 or admin001@gmail.com for more information.")
                        .append("</br>")
                        .append("<p>Sinerely</p>").append("</br>").append("<h2>Stay With Me</h2>");
                break;
        }
        return builder.toString();
    }

    private String generateLandlordRejectedMailSubject(String username, String reason) {
        StringBuilder builder = new StringBuilder();
        builder.append("<h1>We're sorry</h1>").append("</br>").append(
                "<p>Your account <span style=\"font-weight:bold;color:orange\">").append(username).append("</span>")
                .append(" had been rejected due to ");
        switch (LandlordStatus.valueOf(reason)) {
            case REJECTED_ID_NUMBER_NOT_MATCHED_IMAGE:
                builder.append("your identity number not match with the image you had provided us.");
                break;
            case REJECTED_ID_BACK_IMAGE:
                builder.append("your image of the back of identity card is invalid.");
            case REJECTED_ID_FRONT_IMAGE:
                builder.append("your image of the front of identity card is invalid.");
                break;
            default:
                break;

        }
        builder.append("</br>")
                .append("<p>Please contact us via phone 0981874736 or admin001@gmail.com for more information.</p>")
                .append("</br>")
                .append("<p>Sinerely</p>").append("</br>").append("<h2>Stay With Me</h2>");

        return builder.toString();
    }

    private String passwordModificationOtpGenerator() {
        RandomString otpGenerator = new RandomString(6);
        return otpGenerator.nextString();
    }

    // private String generateInformBookingMailSubject(Booking booking) {
    // Landlord landlordProperty = booking.getBookingHomestays().stream().map(h ->
    // h.getHomestay().getLandlord())
    // .findAny().get();
    // StringBuilder informMailBuilder = new StringBuilder();
    // informMailBuilder.append("<h1>Dear
    // ").append(landlordProperty.getUser().getUsername())
    // .append("</h1>").append("</br>").append("<p> you have
    // ").append(booking.getBookingHomestays().size())
    // .append("new booking from ")
    // .append(booking.getPassenger().getUser().getUsername()).append(" for ")
    // .append(" at ").append(booking.getCreatedDate())
    // .append(". </p>").append("</br>").append("<p>").append("The booking will
    // start from ")
    // .append("so please go to www.google.com for more details.</p>")
    // .append("</br>").append("<h2>Good luck</h2>");
    // return informMailBuilder.toString();
    // }

    @Override
    public void approveLandlordAccount(SwmUser user) {
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage);
        try {
            helper.setTo(new InternetAddress(user.getEmail()));
            helper.setFrom("no-reply@swm.com", "stay_with_me");
            helper.setSubject("Landlord account");
            helper.setText(generateLandlordApprovedMailSubject(user.getUsername()), true);
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
                    generateLandlordRejectedMailSubject(user.getUsername(), user.getLandlordProperty().getStatus()),
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
                helper.setText(generateApproveHomestayMailSubject(homestay.getName(), this.HOMESTAY), true);
            } else if (bloc != null && homestay == null) {
                helper.setTo(new InternetAddress(bloc.getLandlord().getUser().getEmail()));
                helper.setText(generateApproveHomestayMailSubject(bloc.getName(), this.BLOC_HOMESTAY), true);
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
                helper.setText(generateRejectHomestayMailSubject(homestay.getName(), this.HOMESTAY), true);
            } else if (bloc != null && homestay == null) {
                helper.setTo(new InternetAddress(bloc.getLandlord().getUser().getEmail()));
                helper.setText(generateRejectHomestayMailSubject(bloc.getName(), this.BLOC_HOMESTAY), true);
            }
            helper.setFrom("no-reply@swm.com", "stay_with_me");
            helper.setSubject("Homestay pending");
            mailSender.send(mimeMessage);
        } catch (MessagingException | UnsupportedEncodingException e) {
            throw new RuntimeException(e.getMessage());
        }
    }

    @Override
    public void informBookingToLandlord(Booking booking) {
        // Landlord landlordProperty = booking.getBookingHomestays().stream().map(h ->
        // h.getHomestay().getLandlord())
        // .findAny().get();
        // MimeMessage mimeMessage = mailSender.createMimeMessage();
        // MimeMessageHelper helper = new MimeMessageHelper(mimeMessage);
        // try {
        // helper.setTo(new InternetAddress(landlordProperty.getUser().getEmail()));
        // helper.setFrom("no-reply@swm.com", "stay_with_me");
        // helper.setSubject("New booking");
        // helper.setText(generateInformBookingMailSubject(booking), true);
        // mailSender.send(mimeMessage);

        // } catch (MessagingException | UnsupportedEncodingException e) {
        // throw new RuntimeException(e.getMessage());
        // }
    }
}
