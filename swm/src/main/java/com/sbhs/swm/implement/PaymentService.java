package com.sbhs.swm.implement;

import java.util.List;
import java.util.Random;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.sbhs.swm.dto.MomoCaptureWalletDto;
import com.sbhs.swm.handlers.exceptions.DuplicateException;
import com.sbhs.swm.models.PaymentHistory;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.models.type.PaymentMethod;
import com.sbhs.swm.models.type.WalletType;
import com.sbhs.swm.repositories.PaymentRepo;
import com.sbhs.swm.services.IPaymentService;
import com.sbhs.swm.services.IUserService;
import com.sbhs.swm.util.DateTimeUtil;
import com.sbhs.swm.util.MomoSignatureHashingUtil;

@Service
public class PaymentService implements IPaymentService {

        @Autowired
        private PaymentRepo paymentRepo;

        @Autowired
        private IUserService userService;

        @Autowired
        private DateTimeUtil dateFormatUtil;

        @Autowired
        private String getPartnerCode;

        @Autowired
        private String getAccessKey;

        @Autowired
        private String getSecretKey;

        @Autowired
        private String getRequestType;

        @Autowired
        private String getCreateOrderUrl;

        @Autowired
        private String getRedirectUrl;

        @Autowired
        private String getIpnUrl;

        @Autowired
        private RestTemplate restTemplate;

        private Random random = new Random();

        @Override
        public MomoCaptureWalletDto processPayment(Long amount, String walletType) {
                String orderId = "MM".concat(String.valueOf(1000000000 + random.nextInt(90000000)));
                while (paymentRepo.findPaymentHistoryByOrderId(orderId).isPresent()) {
                        orderId = "MM".concat(String.valueOf(1000000000 + random.nextInt(90000000)));
                }
                String requestId = "MM".concat(String.valueOf(1000000000 + random.nextInt(90000000)));
                MomoCaptureWalletDto momoCaptureWalletDto = new MomoCaptureWalletDto();
                momoCaptureWalletDto.setAmount(amount);
                momoCaptureWalletDto.setExtraData(userService.authenticatedUser().getUsername());
                momoCaptureWalletDto.setIpnUrl(getIpnUrl);
                momoCaptureWalletDto.setLang("en");
                momoCaptureWalletDto.setOrderId(orderId);
                momoCaptureWalletDto.setOrderInfo(walletType);
                momoCaptureWalletDto.setPartnerCode(getPartnerCode);
                momoCaptureWalletDto.setRedirectUrl(getRedirectUrl);
                momoCaptureWalletDto.setRequestId(requestId);
                momoCaptureWalletDto.setRequestType(getRequestType);
                momoCaptureWalletDto.setSignature(this.configSignature(amount, walletType, orderId, requestId));

                HttpHeaders headers = new HttpHeaders();
                headers.setContentType(MediaType.APPLICATION_JSON);
                MomoCaptureWalletDto momoCaptureWalletDtoResponse = restTemplate.postForObject(getCreateOrderUrl,
                                momoCaptureWalletDto, MomoCaptureWalletDto.class, headers);

                return momoCaptureWalletDtoResponse;
        }

        private String configSignature(Long amount, String walletType, String orderId, String requestId) {
                StringBuilder rawHashBuilder = new StringBuilder();

                rawHashBuilder.append("accessKey=").append(getAccessKey).append("&amount=")
                                .append(amount.toString())
                                .append("&extraData=").append(userService.authenticatedUser().getUsername())
                                .append("&ipnUrl=")
                                .append(getIpnUrl).append("&orderId=")
                                .append(orderId).append("&orderInfo=").append(walletType)
                                .append("&partnerCode=").append(getPartnerCode).append("&redirectUrl=")
                                .append(getRedirectUrl)
                                .append("&requestId=").append(requestId).append("&requestType=")
                                .append(getRequestType);
                String signature = MomoSignatureHashingUtil.sha256HashSigningKey(getSecretKey,
                                rawHashBuilder.toString());

                return signature;
        }

        @Override
        @Transactional
        public MomoCaptureWalletDto paymentResultHandling(MomoCaptureWalletDto momoCaptureWalletDto) {
                SwmUser user = userService.findUserByUsername(momoCaptureWalletDto.getExtraData());
                WalletType walletType = WalletType.valueOf(momoCaptureWalletDto.getOrderInfo());
                if (paymentRepo.findPaymentHistoryByOrderId(momoCaptureWalletDto.getOrderId()).isPresent()) {
                        throw new DuplicateException("Not valid request");
                }
                switch (walletType) {
                        case PASSENGER_WALLET:
                                long currentPassengerBalance = user.getPassengerProperty().getBalanceWallet()
                                                .getTotalBalance();
                                user.getPassengerProperty().getBalanceWallet()
                                                .setTotalBalance(currentPassengerBalance
                                                                + momoCaptureWalletDto.getAmount());
                                PaymentHistory paymentHistory = new PaymentHistory();
                                paymentHistory.setAmount(momoCaptureWalletDto.getAmount());
                                paymentHistory.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
                                paymentHistory
                                                .setPassengerWallet(user.getPassengerProperty().getBalanceWallet()
                                                                .getPassengerWallet());
                                paymentHistory.setPaymentMethod(PaymentMethod.SWM_WALLET.name());
                                PaymentHistory savedPaymentHistory = paymentRepo.save(paymentHistory);
                                paymentHistory.setOrderId(momoCaptureWalletDto.getOrderId());
                                user.getPassengerProperty().getBalanceWallet().getPassengerWallet()
                                                .setPaymentHistories(List.of(savedPaymentHistory));
                                break;
                        case LANDLORD_WALLET:
                                long currentLandlordBalance = user.getLandlordProperty().getBalanceWallet()
                                                .getTotalBalance();
                                user.getPassengerProperty().getBalanceWallet()
                                                .setTotalBalance(currentLandlordBalance
                                                                + momoCaptureWalletDto.getAmount());
                                PaymentHistory paymentHistoryForLandlord = new PaymentHistory();
                                paymentHistoryForLandlord.setAmount(momoCaptureWalletDto.getAmount());
                                paymentHistoryForLandlord.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
                                paymentHistoryForLandlord
                                                .setLandlordWallet(user.getLandlordProperty().getBalanceWallet()
                                                                .getLandlordWallet());
                                paymentHistoryForLandlord.setPaymentMethod(PaymentMethod.SWM_WALLET.name());
                                PaymentHistory savedPaymentHistoryForLandlord = paymentRepo
                                                .save(paymentHistoryForLandlord);
                                user.getLandlordProperty().getBalanceWallet().getLandlordWallet()
                                                .setPaymentHistories(List.of(savedPaymentHistoryForLandlord));
                }
                return null;
        }

        @Override
        public Page<PaymentHistory> findPaymentHistoriesOfPassenger(int page, int size, boolean isNextPage,
                        boolean isPreviousPage) {
                String username = userService.authenticatedUser().getUsername();
                Pageable pageable = PageRequest.of(page, size);
                Page<PaymentHistory> paymentHistories = paymentRepo.findPaymentHistoriesByPassenger(pageable, username);
                if (paymentHistories.hasNext() && isNextPage == true && isPreviousPage == false) {
                        paymentHistories = paymentRepo.findPaymentHistoriesByPassenger(paymentHistories.nextPageable(),
                                        username);
                } else if (paymentHistories.hasPrevious() && isPreviousPage == true && isNextPage == false) {
                        paymentHistories = paymentRepo.findPaymentHistoriesByPassenger(
                                        paymentHistories.previousPageable(),
                                        username);
                }

                return paymentHistories;
        }

}
