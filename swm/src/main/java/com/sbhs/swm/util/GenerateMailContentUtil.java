package com.sbhs.swm.util;

import java.text.NumberFormat;

import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

import org.modelmapper.internal.bytebuddy.utility.RandomString;
import org.springframework.beans.factory.annotation.Autowired;

import com.sbhs.swm.models.Booking;
import com.sbhs.swm.models.BookingHomestay;
import com.sbhs.swm.models.BookingHomestayService;
import com.sbhs.swm.models.BookingInviteCode;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.models.status.LandlordStatus;
import com.sbhs.swm.models.type.HomestayType;

public class GenerateMailContentUtil {
    @Autowired
    private static DateTimeUtil dateFormatUtil = new DateTimeUtil();

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

    public static String generateInformBookingSharedCodeHadBeenApplied(BookingInviteCode bookingShareCode,
            String username) {
        StringBuilder informMailBuilder = new StringBuilder();
        SwmUser bookingHost = bookingShareCode.getBooking().getPassenger().getUser();

        String bookingCode = bookingShareCode.getBooking().getCode();
        informMailBuilder.append("<h1>").append("Dear ").append(bookingHost.getUsername()).append("</h1>")
                .append("</br>")
                .append("<p>").append("Currently, user ").append(username)
                .append(" use share code on your booking ").append(bookingCode).append("<br>").append("<p>")
                .append("Now you can share the remain deposit with your guest.").append("</p>").append("</br>");
        return informMailBuilder.toString();
    }

    public static String generateInformAcceptBookingForHomestay(BookingHomestay bookingHomestay) {
        StringBuilder informMailBuilder = new StringBuilder();
        Locale locale = new Locale("vi", "VN");
        NumberFormat vndNumberFormat = NumberFormat.getCurrencyInstance(locale);

        Booking booking = bookingHomestay.getBooking();

        int duration = dateFormatUtil.differenceInDays(booking.getBookingFrom(), booking.getBookingTo());
        String bookingTotalPrice = vndNumberFormat.format(bookingHomestay.getTotalBookingPrice().doubleValue());

        SwmUser user = booking.getPassenger().getUser();
        informMailBuilder.append("<h1>").append("Dear ").append(user.getUsername()).append("</h1>")
                .append("</br>")
                .append("<p>").append("Your booking for homestay ").append(bookingHomestay.getHomestay().getName())
                .append(" in booking ").append(booking.getCode())
                .append(" has been accepted.").append("</br>").append("Quick information:").append("</br>")
                .append("<ul>")
                .append("<li style='font-weight:bold'>").append("You'll stay there for ").append(duration)
                .append(" days.From ").append(booking.getBookingFrom()).append(" to ").append(booking.getBookingTo())
                .append("</li>")
                .append("<li style='font-weight:bold'>").append("The homestay locate at ")
                .append(bookingHomestay.getHomestay().getAddress()
                        .split("_")[0])
                .append("</li>").append("<li style='font-weight:bold'>").append("Total booking price ")
                .append(bookingTotalPrice).append("</li>");
        // .append("</ul>");

        if (booking.getBookingHomestayServices().stream()
                .filter(s -> s.getHomestayName().equals(bookingHomestay.getHomestay().getName())).findAny()
                .isPresent()) {
            List<BookingHomestayService> bookingHomestayServiceList = booking.getBookingHomestayServices().stream()
                    .filter(s -> s.getHomestayName().equals(bookingHomestay.getHomestay().getName()))
                    .collect(Collectors.toList());
            informMailBuilder.append("<li style='font-weight:bold'>").append("You've booked ")
                    .append(bookingHomestayServiceList.size()).append(" services").append("</li>");
        }

        informMailBuilder.append("<p>Sinerely</p>").append("</br>").append("<h2>Stay With Me</h2>");
        return informMailBuilder.toString();
    }

    public static String generateInformAcceptBookingForBloc(Booking booking) {
        StringBuilder informMailBuilder = new StringBuilder();
        Locale locale = new Locale("vi", "VN");
        NumberFormat vndNumberFormat = NumberFormat.getCurrencyInstance(locale);

        int duration = dateFormatUtil.differenceInDays(booking.getBookingFrom(), booking.getBookingTo());
        String bookingTotalPrice = vndNumberFormat.format(booking.getTotalBookingPrice().doubleValue());

        SwmUser user = booking.getPassenger().getUser();
        informMailBuilder.append("<h1>").append("Dear ").append(user.getUsername()).append("</h1>")
                .append("</br>")
                .append("<p>").append("Your booking for block ").append(booking.getBloc().getName())
                .append(" in booking ").append(booking.getCode())
                .append(" has been accepted.").append("</br>").append("Quick information:").append("</br>")
                .append("<ul>")
                .append("<li style='font-weight:bold'>").append("You'll stay there for ").append(duration)
                .append(" days.From ").append(booking.getBookingFrom()).append(" to ").append(booking.getBookingTo())
                .append("</li>")
                .append("<li style='font-weight:bold'>").append("The homestay locate at ")
                .append(booking.getBloc().getAddress()
                        .split(booking.getBloc().getAddress().split("_")[0]))
                .append("</li>").append("<li style='font-weight:bold'>").append("Total booking price ")
                .append(bookingTotalPrice).append("</li>");
        // .append("</ul>");

        if (booking.getBookingHomestayServices().stream()
                .filter(s -> s.getHomestayName().equals(booking.getBloc().getName())).findAny()
                .isPresent()) {
            List<BookingHomestayService> bookingHomestayServiceList = booking.getBookingHomestayServices().stream()
                    .filter(s -> s.getHomestayName().equals(booking.getBloc().getName()))
                    .collect(Collectors.toList());
            informMailBuilder.append("<li style='font-weight:bold'>").append("You've booked ")
                    .append(bookingHomestayServiceList.size()).append(" services").append("</li>");
        }

        informMailBuilder.append("<p>Sinerely</p>").append("</br>").append("<h2>Stay With Me</h2>");
        return informMailBuilder.toString();
    }

    public static String generateInformRejectBookingForHomestay(BookingHomestay bookingHomestay, String message) {
        Booking booking = bookingHomestay.getBooking();
        String bookingCode = booking.getCode();
        SwmUser user = booking.getPassenger().getUser();
        SwmUser landlord = bookingHomestay.getHomestay().getLandlord().getUser();
        StringBuilder informMailBuilder = new StringBuilder();
        informMailBuilder.append("<h1>").append("Dear ").append(user.getUsername()).append("</h1>")
                .append("</br>")
                .append("<p>").append("Your homestay ").append(bookingHomestay.getHomestay().getName())
                .append(" in booking ").append(bookingCode).append(" has been rejected.").append("</p>").append("</br>")
                .append("<p>")
                .append("Here is message from landlord: ").append("</p>").append("</br>")
                .append("<p style='font-weight:bold'>").append(message).append("</p>").append("</br>").append("<p>")
                .append("You can contact landlord by: ").append("</br>").append("<ul>")
                .append("<li style='font-weight:bold'>").append("Name: ").append(landlord.getUsername()).append("</li>")
                .append("<li style='font-weight:bold'>").append("Email: ").append(landlord.getEmail()).append("</li>")
                .append("<li style='font-weight:bold'>").append("Phone: ").append(landlord.getPhone()).append("</li>")
                .append("</ul>");
        return informMailBuilder.toString();
    }

    public static String generateInformRejectBookingForBloc(Booking booking, String message) {

        String bookingCode = booking.getCode();
        SwmUser user = booking.getPassenger().getUser();
        SwmUser landlord = booking.getBloc().getLandlord().getUser();
        StringBuilder informMailBuilder = new StringBuilder();
        informMailBuilder.append("<h1>").append("Dear ").append(user.getUsername()).append("</h1>")
                .append("</br>")
                .append("<p>").append("Your block ").append(booking.getBloc().getName())
                .append(" in booking ").append(bookingCode).append(" has been rejected.").append("</p>").append("</br>")
                .append("<p>")
                .append("Here is message from landlord: ").append("</p>").append("</br>")
                .append("<p style='font-weight:bold'>").append(message).append("</p>").append("</br>").append("<p>")
                .append("You can contact landlord by: ").append("</br>").append("<ul>")
                .append("<li style='font-weight:bold'>").append("Name: ").append(landlord.getUsername()).append("</li>")
                .append("<li style='font-weight:bold'>").append("Email: ").append(landlord.getEmail()).append("</li>")
                .append("<li style='font-weight:bold'>").append("Phone: ").append(landlord.getPhone()).append("</li>")
                .append("</ul>");
        return informMailBuilder.toString();
    }
}
