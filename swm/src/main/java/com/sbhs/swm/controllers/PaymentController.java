package com.sbhs.swm.controllers;

import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletResponse;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.sbhs.swm.dto.MomoCaptureWalletDto;
import com.sbhs.swm.dto.paging.PaymentHistoryListPagingDto;
import com.sbhs.swm.dto.response.PaymentHistoryResponseDto;
import com.sbhs.swm.models.PaymentHistory;
import com.sbhs.swm.services.IPaymentService;

@RestController
@RequestMapping("/api/payment")
public class PaymentController {

        @Autowired
        private IPaymentService paymentService;

        @Autowired
        private ModelMapper modelMapper;

        @PutMapping
        @PreAuthorize("hasRole('ROLE_PASSENGER')")
        public ResponseEntity<?> passengerPayment(@RequestParam Long amount, @RequestParam String walletType) {
                MomoCaptureWalletDto momoCaptureWalletDtoResponse = paymentService.processPayment(amount, walletType);

                return new ResponseEntity<MomoCaptureWalletDto>(momoCaptureWalletDtoResponse, HttpStatus.OK);
        }

        @GetMapping("/list")
        @PreAuthorize("hasRole('ROLE_PASSENGER')")
        public ResponseEntity<?> getPassengerPaymentHistories(@RequestParam int page, @RequestParam int size,
                        @RequestParam boolean isNextPage, @RequestParam boolean isPreviousPage) {
                Page<PaymentHistory> paymentHistories = paymentService.findPaymentHistoriesOfPassenger(page, size,
                                isNextPage,
                                isPreviousPage);
                List<PaymentHistoryResponseDto> paymentHistoryDtos = paymentHistories.stream()
                                .map(p -> modelMapper.map(p, PaymentHistoryResponseDto.class))
                                .collect(Collectors.toList());
                PaymentHistoryListPagingDto paymentHistoriesPagingDto = new PaymentHistoryListPagingDto(
                                paymentHistoryDtos,
                                paymentHistories.getNumber());

                return new ResponseEntity<PaymentHistoryListPagingDto>(paymentHistoriesPagingDto, HttpStatus.OK);
        }

        @GetMapping("/redirect")
        public ResponseEntity<?> paymentResultHandling(@RequestParam String partnerCode, @RequestParam String orderId,
                        @RequestParam String requestId, @RequestParam Long amount, @RequestParam String orderInfo,
                        @RequestParam String orderType, @RequestParam Long transId, @RequestParam String resultCode,
                        @RequestParam String message, @RequestParam String payType, @RequestParam String extraData,
                        @RequestParam String signature, HttpServletResponse response) {

                MomoCaptureWalletDto momoCaptureWalletDto = new MomoCaptureWalletDto(partnerCode, requestId, amount,
                                orderId,
                                orderInfo, orderType, resultCode, requestId, extraData, payType, signature, transId,
                                message, null,
                                extraData, signature);
                MomoCaptureWalletDto momoCaptureWalletHandled = paymentService
                                .paymentResultHandling(momoCaptureWalletDto);

                return new ResponseEntity<MomoCaptureWalletDto>(momoCaptureWalletHandled, HttpStatus.OK);
        }
}
