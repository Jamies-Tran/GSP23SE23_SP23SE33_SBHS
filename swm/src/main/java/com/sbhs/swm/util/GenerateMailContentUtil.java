package com.sbhs.swm.util;

import org.modelmapper.internal.bytebuddy.utility.RandomString;

import com.sbhs.swm.models.BookingShareCode;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.models.status.LandlordStatus;
import com.sbhs.swm.models.type.HomestayType;

public class GenerateMailContentUtil {
    public static String generatePassengerChangePasswordOtpMailSubject(String otp) {
        StringBuilder builder = new StringBuilder();
        builder.append(
                "<center><p style=\"letter-spacing:1.0;font-family:courier;\">Here is your otp code:</p></center></br><center><h1>")
                .append(otp).append("</h1></center>");
        return builder.toString();
    }

    public static String generateLandlordApprovedMailSubject(String username) {
        StringBuilder builder = new StringBuilder();
        builder.append("<h1>You are now a partner of Stay With Me</h1>").append("</br>").append(
                "<p>Your account <span style=\"font-weight:bold;color:orange\">").append(username)
                .append("</span> had been approved and now can access our <a href=\"https://www.google.com/\">website</a></p>")
                .append("</br>").append("<p>We're look forward to working with you soon.</p>").append("</br>")
                .append("<p>Sinerely</p>").append("</br>").append("<h2>Stay With Me</h2>");
        return builder.toString();
    }

    public static String generateApproveHomestayMailSubject(String name, String style) {
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

    public static String generateRejectHomestayMailSubject(String name, String style) {
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

    public static String generateLandlordRejectedMailSubject(String username, String reason) {
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

    public static String passwordModificationOtpGenerator() {
        RandomString otpGenerator = new RandomString(6);
        return otpGenerator.nextString();
    }

    public static String generateInformBookingMailSubject(String landlordName, String passengerName,
            String createdDate, String homestayType, int numberOfHomestayBooked, String blocName) {
        StringBuilder informMailBuilder = new StringBuilder();
        switch (HomestayType.valueOf(homestayType)) {
            case HOMESTAY:
                informMailBuilder.append("<h1>Dear ").append(landlordName)
                        .append("</h1>").append("</br>").append("<p> you have")
                        .append("new booking from ")
                        .append(passengerName)
                        .append(" at ").append(createdDate)
                        .append(". </p>").append("</br>").append("<p>").append("The booking will start from ")
                        .append("so please go to www.google.com for more details.</p>")
                        .append("</br>").append("<h2>Good luck</h2>");
                break;
            case BLOC:
                informMailBuilder.append("<h1>Dear ").append(landlordName)
                        .append("</h1>").append("</br>").append("<p> you have")
                        .append("new booking from ")
                        .append(passengerName).append(" for ").append(numberOfHomestayBooked).append(" on bloc ")
                        .append(blocName)
                        .append(" at ").append(createdDate)
                        .append(". </p>").append("</br>").append("<p>").append("The booking will start from ")
                        .append("so please go to www.google.com for more details.</p>")
                        .append("</br>").append("<h2>Good luck</h2>");
                break;

        }
        return informMailBuilder.toString();
    }

    public static String generateLowBalanceInformLandlordMailSubject(String username) {
        StringBuilder informMailBuilder = new StringBuilder();
        informMailBuilder.append("<h1>").append("Dear ").append(username).append("</h1>").append("</br>")
                .append("<center>").append("<p>")
                .append("Currently, your account balance is under 50.000 VND. Please add more for further operation.")
                .append("</p>").append("</center>");
        return informMailBuilder.toString();
    }

    public static String generateInformBookingSharedCodeHadBeenApplied(BookingShareCode bookingShareCode) {
        StringBuilder informMailBuilder = new StringBuilder();
        SwmUser bookingHost = bookingShareCode.getBooking().getPassenger().getUser();
        SwmUser bookingGuest = bookingShareCode.getPassenger().getUser();
        String bookingCode = bookingShareCode.getBooking().getCode();
        informMailBuilder.append("<h1>").append("Dear ").append(bookingHost.getUsername()).append("</h1>")
                .append("</br>")
                .append("<p>").append("Currently, user ").append(bookingGuest.getUsername())
                .append(" use share code on your booking ").append(bookingCode).append("<br>").append("<p>")
                .append("Now you can share the remain deposit with your guest.").append("</p>").append("</br>");
        return informMailBuilder.toString();
    }
}
