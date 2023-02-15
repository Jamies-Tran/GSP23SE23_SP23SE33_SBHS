package com.sbhs.swm.services;

import java.util.List;

import com.sbhs.swm.dto.MomoCaptureWalletDto;
import com.sbhs.swm.models.PaymentHistory;

public interface IPaymentService {
    MomoCaptureWalletDto processPayment(Long amount, String walletType);

    MomoCaptureWalletDto paymentResultHandling(MomoCaptureWalletDto momoCaptureWalletDto);

    List<PaymentHistory> findPaymentHistoriesOfPassenger(int page, int size);
}
