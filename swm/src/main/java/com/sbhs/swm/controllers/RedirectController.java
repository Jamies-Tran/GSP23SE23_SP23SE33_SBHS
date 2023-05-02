package com.sbhs.swm.controllers;

import java.io.IOException;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sbhs.swm.dto.MomoCaptureWalletDto;
import com.sbhs.swm.services.IPaymentService;

@Controller
public class RedirectController {
    @Autowired
    private IPaymentService paymentService;

    @GetMapping("/api/payment/redirect")
    public void paymentResultHandling(@RequestParam String partnerCode, @RequestParam String orderId,
            @RequestParam String requestId, @RequestParam Long amount, @RequestParam String orderInfo,
            @RequestParam String orderType, @RequestParam Long transId, @RequestParam String resultCode,
            @RequestParam String message, @RequestParam String payType, @RequestParam String extraData,
            @RequestParam String signature, HttpServletResponse response) {

        MomoCaptureWalletDto momoCaptureWalletDto = new MomoCaptureWalletDto(partnerCode, requestId, amount,
                orderId,
                orderInfo, orderType, resultCode, requestId, extraData, payType, signature, transId,
                message, null,
                extraData, signature);
        paymentService
                .paymentResultHandling(momoCaptureWalletDto);

        try {
            response.sendRedirect("/payment-success");
        } catch (IOException e) {

            e.printStackTrace();
        }
    }

    @GetMapping("/payment-success")
    public String redirectPaymentSuccess() {
        return "payment_success";
    }
}
