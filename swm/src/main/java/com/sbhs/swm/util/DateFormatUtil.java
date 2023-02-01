package com.sbhs.swm.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
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

    public Date formatGivenDate(String date) {
        try {
            return simpleDateFormat.parse(date);
        } catch (ParseException e) {
            throw new InvalidDateException(date);
        }
    }
}
