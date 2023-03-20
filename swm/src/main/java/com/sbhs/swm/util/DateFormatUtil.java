package com.sbhs.swm.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.Period;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;

import com.sbhs.swm.handlers.exceptions.InvalidDateException;

@Configuration
public class DateFormatUtil {
    @Autowired
    private SimpleDateFormat simpleDateFormat;

    public Date formatDateTimeNow() {
        Date now = new Date();
        try {
            return simpleDateFormat.parse(simpleDateFormat.format(now));
        } catch (ParseException e) {
            throw new InvalidDateException(now.toString());
        }
    }

    public int calculateAge(String dob) {
        Date formatDobDate = this.formatGivenDate(dob);
        String formatDob = this.formatGivenDateTimeToString(formatDobDate);
        LocalDate birthdate = LocalDate.of(Integer.parseInt(formatDob.split("-")[0]),
                Integer.parseInt(formatDob.split("-")[1]), Integer.parseInt(formatDob.split("-")[2]));
        LocalDate now = LocalDate.now();
        return Period.between(birthdate, now).getYears();
    }

    public int calculateDurationBooking(String bookingStart, String bookingEnd) {
        LocalDate localStartDate = LocalDate.of(Integer.parseInt(bookingStart.split("-")[0]),
                Integer.parseInt(bookingStart.split("-")[1]), Integer.parseInt(bookingStart.split("-")[2]));
        LocalDate localEndDate = LocalDate.of(Integer.parseInt(bookingEnd.split("-")[0]),
                Integer.parseInt(bookingEnd.split("-")[1]), Integer.parseInt(bookingEnd.split("-")[2]));
        return Period.between(localStartDate, localEndDate).getDays();
    }

    public Date formatGivenDate(String date) {
        try {
            return simpleDateFormat.parse(date);
        } catch (ParseException e) {
            throw new InvalidDateException(date);
        }
    }

    public String formatDateTimeNowToString() {
        Date now = new Date();
        return simpleDateFormat.format(now);
    }

    public String formatGivenDateTimeToString(Date date) {
        return simpleDateFormat.format(date);
    }
}
