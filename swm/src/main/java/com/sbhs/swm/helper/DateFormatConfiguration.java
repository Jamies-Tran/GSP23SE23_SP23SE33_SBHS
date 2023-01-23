package com.sbhs.swm.helper;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class DateFormatConfiguration {
    private SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");

    @Bean
    public String formatDateToString(@Qualifier("date") Date date) {
        return simpleDateFormat.format(date);
    }
}
