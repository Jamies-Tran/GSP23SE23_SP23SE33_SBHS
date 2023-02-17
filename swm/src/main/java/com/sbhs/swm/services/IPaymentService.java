package com.sbhs.swm.services;

import org.springframework.data.domain.Page;

import com.sbhs.swm.dto.MomoCaptureWalletDto;
import com.sbhs.swm.models.PaymentHistory;

public interface IPaymentService {
    MomoCaptureWalletDto processPayment(Long amount, String walletType);

    MomoCaptureWalletDto paymentResultHandling(MomoCaptureWalletDto momoCaptureWalletDto);

    Page<PaymentHistory> findPaymentHistoriesOfPassenger(int page, int size, boolean isNextPage,
            boolean isPreviousPage);
}
