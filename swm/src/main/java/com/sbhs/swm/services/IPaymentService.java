package com.sbhs.swm.services;

import com.sbhs.swm.dto.MomoCaptureWalletDto;

public interface IPaymentService {
    MomoCaptureWalletDto processPayment(Long amount, String walletType);

    MomoCaptureWalletDto paymentResultHandling(MomoCaptureWalletDto momoCaptureWalletDto);
}
