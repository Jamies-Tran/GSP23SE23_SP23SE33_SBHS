package com.sbhs.swm.implement;

import java.io.UnsupportedEncodingException;

import javax.mail.MessagingException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.sbhs.swm.services.IMailService;
import com.sbhs.swm.services.IUserService;

import net.bytebuddy.utility.RandomString;

@Service
public class MailService implements IMailService {

    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    @Lazy
    private IUserService userService;

    @Override
    public void userChangePasswordOtpMailSender(String email) {
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage);
        String otp = passwordModificationOtpGenerator();
        try {
            helper.setTo(new InternetAddress(email));
            helper.setFrom("no-reply@swm.com", "stay_with_me");
            helper.setSubject("Change password");
            helper.setText(generatePassengerChangePasswordOtpMailSubject(otp), true);
            mailSender.send(mimeMessage);
            userService
                    .savePasswordModificationOtp(otp, email);
        } catch (MessagingException | UnsupportedEncodingException e) {
            throw new RuntimeException(e.getMessage());
        }
    }

    private String generatePassengerChangePasswordOtpMailSubject(String otp) {
        StringBuilder builder = new StringBuilder();
        builder.append(
                "<center><p style=\"letter-spacing:1.0;font-family:courier;\">Here is your otp code:</p></center></br><center><h1>")
                .append(otp).append("</h1></center>");
        return builder.toString();
    }

    private String passwordModificationOtpGenerator() {
        RandomString otpGenerator = new RandomString(6);
        return otpGenerator.nextString();
    }
}
