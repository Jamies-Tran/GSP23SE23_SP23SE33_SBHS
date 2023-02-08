package com.sbhs.swm.implement;

import java.util.List;
import java.util.Optional;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import com.sbhs.swm.handlers.exceptions.EmailDuplicateException;
import com.sbhs.swm.handlers.exceptions.EmailNotFoundException;
import com.sbhs.swm.handlers.exceptions.InvalidUserStatusException;
import com.sbhs.swm.handlers.exceptions.LoginFailException;
import com.sbhs.swm.handlers.exceptions.PasswordDuplicateException;
import com.sbhs.swm.handlers.exceptions.PasswordModificationException;
import com.sbhs.swm.handlers.exceptions.PhoneDuplicateException;
import com.sbhs.swm.handlers.exceptions.UsernameDuplicateException;
import com.sbhs.swm.handlers.exceptions.UsernameNotFoundException;
import com.sbhs.swm.handlers.exceptions.VerifyPassModificationFailException;
import com.sbhs.swm.models.BalanceWallet;
import com.sbhs.swm.models.Landlord;
import com.sbhs.swm.models.Passenger;
import com.sbhs.swm.models.PassengerWallet;
import com.sbhs.swm.models.PasswordModificationOtp;
import com.sbhs.swm.models.SwmRole;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.models.status.LandlordStatus;
import com.sbhs.swm.repositories.PasswordModificationOtpRepo;
import com.sbhs.swm.repositories.UserRepo;
import com.sbhs.swm.services.IMailService;
import com.sbhs.swm.services.IRoleService;
import com.sbhs.swm.services.IUserService;

@Service
public class UserService implements IUserService {

    @Autowired
    private UserRepo userRepo;

    @Autowired
    private PasswordModificationOtpRepo passwordModificationOtpRepo;

    @Autowired
    private IRoleService roleService;

    @Autowired
    private IMailService mailService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public SwmUser findUserByUsername(String username) {
        return userRepo.findByUsername(username).orElseThrow(() -> new UsernameNotFoundException(username));
    }

    @Override
    public SwmUser registerPassengerAccount(SwmUser user) {
        if (userRepo.findByUsername(user.getUsername()).isPresent()) {
            throw new UsernameDuplicateException();
        } else if (userRepo.findByEmail(user.getEmail()).isPresent()) {
            throw new EmailDuplicateException();
        } else if (userRepo.findByPhone(user.getPhone()).isPresent()) {
            throw new PhoneDuplicateException();
        }
        Passenger passenger = new Passenger();
        PassengerWallet passengerWallet = new PassengerWallet();
        BalanceWallet balanceWallet = new BalanceWallet();
        balanceWallet.setPassengerWallet(passengerWallet);
        balanceWallet.setPassenger(passenger);
        passengerWallet.setPassengerBalanceWallet(balanceWallet);
        passenger.setPassengerWallet(balanceWallet);

        SwmRole passengerRole = roleService.findRoleByName("passenger");
        passengerRole.setUsers(List.of(user));
        user.setRoles(List.of(passengerRole));
        user.setPassengerProperty(passenger);

        user.setPassword(passwordEncoder.encode(user.getPassword()));
        SwmUser savedUser = userRepo.save(user);
        return savedUser;
    }

    @Override
    public SwmUser registerLandlordAccount(SwmUser user) {
        if (userRepo.findByUsername(user.getUsername()).isPresent()) {
            throw new UsernameDuplicateException();
        } else if (userRepo.findByEmail(user.getEmail()).isPresent()) {
            throw new EmailDuplicateException();
        } else if (userRepo.findByPhone(user.getPhone()).isPresent()) {
            throw new PhoneDuplicateException();
        }
        Landlord landlord = new Landlord();
        // BalanceWallet balanceWallet = new BalanceWallet();
        // balanceWallet.setLandlord(landlord);
        // landlord.setLandlordWallet(balanceWallet);
        SwmRole landlordRole = roleService.findRoleByName("landlord");
        landlordRole.setUsers(List.of(user));
        user.setRoles(List.of(landlordRole));
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setLandlordProperty(landlord);
        landlord.setUser(user);
        SwmUser savedUser = userRepo.save(user);
        return savedUser;
    }

    @Override
    public boolean validateEmail(String email) {
        Optional<SwmUser> user = userRepo.findByEmail(email);

        return user.isEmpty();
    }

    @Override
    public SwmUser login(String username, String password) {
        Optional<SwmUser> checkUsername = userRepo.findByUsername(username);
        if (checkUsername.isPresent()) {
            SwmUser user = checkUsername.get();
            if (user.getLandlordProperty() != null
                    && !user.getLandlordProperty().getStatus().equalsIgnoreCase(LandlordStatus.ACTIVATED.name())) {
                throw new InvalidUserStatusException();
            } else {
                if (passwordEncoder.matches(password, user.getPassword())) {
                    return user;
                } else {
                    throw new LoginFailException();
                }
            }

        } else {
            throw new LoginFailException();
        }

    }

    @Override
    public PasswordModificationOtp savePasswordModificationOtp(String otp, String email) {
        SwmUser user = userRepo.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException(email));
        PasswordModificationOtp passwordModificationOtp = new PasswordModificationOtp();
        user.setOtpToken(passwordModificationOtp);
        passwordModificationOtp.setOtpToken(otp);
        passwordModificationOtp.setUser(user);
        return passwordModificationOtpRepo.save(passwordModificationOtp);
    }

    @Override
    public void sendPasswordModificationOtpMail(String email) {
        SwmUser user = userRepo.findByEmail(email).orElseThrow(() -> new EmailNotFoundException());
        if (user.getOtpToken() != null) {
            this.deletePasswordOtp(user.getOtpToken().getOtpToken());
        }

        mailService.userChangePasswordOtpMailSender(email);
    }

    @Override
    @Transactional
    public void verifyPasswordModificationByOtp(String otp) {
        PasswordModificationOtp passwordOtp = passwordModificationOtpRepo.findOtpByCode(otp)
                .orElseThrow(() -> new VerifyPassModificationFailException());
        SwmUser user = passwordOtp.getUser();

        user.setChangePassword(true);
        this.deletePasswordOtp(otp);
    }

    @Override
    @Transactional
    public void changePassword(String newPassword, String email) {
        SwmUser user = userRepo.findByEmail(email).orElseThrow(() -> new UsernameNotFoundException(email));
        if (user.isChangePassword()) {
            if (passwordEncoder.matches(newPassword, user.getPassword())) {
                throw new PasswordDuplicateException();
            }
            user.setPassword(passwordEncoder.encode(newPassword));
            user.setChangePassword(false);
        } else {
            throw new PasswordModificationException();
        }
    }

    @Override
    @Transactional
    public void deletePasswordOtp(String otp) {
        PasswordModificationOtp otpToken = passwordModificationOtpRepo.findOtpByCode(otp).orElseThrow();
        otpToken.getUser().setOtpToken(null);
        passwordModificationOtpRepo.delete(otpToken);
    }

    @Override
    public SwmUser loginByGoogle(String email) {
        SwmUser user = userRepo.findByEmail(email).orElseThrow(() -> new UsernameNotFoundException(email));

        return user;
    }

    @Override
    public SwmUser authenticatedUser() {
        UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        return userRepo.findByUsername(userDetails.getUsername())
                .orElseThrow(() -> new UsernameNotFoundException(userDetails.getUsername()));
    }
}
