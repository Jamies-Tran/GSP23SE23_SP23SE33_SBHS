package com.sbhs.swm.implement;

import java.util.Random;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.sbhs.swm.dto.MomoCaptureWalletDto;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.models.type.WalletType;
import com.sbhs.swm.services.IPaymentService;
import com.sbhs.swm.services.IUserService;
import com.sbhs.swm.util.MomoSignatureHashingUtil;

@Service
public class PaymentService implements IPaymentService {

    @Autowired
    private IUserService userService;

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

    private RestTemplate restTemplate = new RestTemplate();

    private Random random = new Random();

    @Override
    public MomoCaptureWalletDto processPayment(Long amount, String walletType) {
        String orderId = "MM".concat(String.valueOf(1000000000 + random.nextInt(90000000)));
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
        String signature = MomoSignatureHashingUtil.sha256HashSigningKey(getSecretKey, rawHashBuilder.toString());

        return signature;
    }

    @Override
    @Transactional
    public MomoCaptureWalletDto paymentResultHandling(MomoCaptureWalletDto momoCaptureWalletDto) {
        SwmUser user = userService.findUserByUsername(momoCaptureWalletDto.getExtraData());
        WalletType walletType = WalletType.valueOf(momoCaptureWalletDto.getOrderInfo());
        switch (walletType) {
            case PASSENGER_WALLET:
                long currentBalance = user.getPassengerProperty().getPassengerWallet()
                        .getTotalBalance();
                user.getPassengerProperty().getPassengerWallet()
                        .setTotalBalance(currentBalance + momoCaptureWalletDto.getAmount());
                break;
            default:
                break;
        }
        return null;
    }

}
