package com.sbhs.swm.configuration;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MomoConfiguration {

    @Value("${momo.partnerCode}")
    private String partnerCode;

    @Value("${momo.accessKey}")
    private String accessKey;

    @Value("${momo.secretKey}")
    private String secretKey;

    @Value("${momo.requestType}")
    private String requestType;

    @Value("${momo.createOrderUrl}")
    private String createOrderUrl;

    @Value("${momo.web.redirectUrl}")
    private String webRedirectUrl;

    @Value("${momo.mobile.redirectUrl}")
    private String mobileRedirectUrl;

    @Value("${momo.ipnUrl}")
    private String ipnUrl;

    @Bean
    public String getPartnerCode() {
        return partnerCode;
    }

    @Bean
    public String getAccessKey() {
        return accessKey;
    }

    @Bean
    public String getSecretKey() {
        return secretKey;
    }

    @Bean
    public String getRequestType() {
        return requestType;
    }

    @Bean
    public String getCreateOrderUrl() {
        return createOrderUrl;
    }

    @Bean
    public String getWebRedirectUrl() {
        return webRedirectUrl;
    }

    @Bean
    public String getMobileRedirectUrl() {
        return mobileRedirectUrl;
    }

    @Bean
    public String getIpnUrl() {
        return ipnUrl;
    }

}
