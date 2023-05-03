package com.sbhs.swm.controllers;

import java.text.SimpleDateFormat;
import java.util.List;

import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.support.PagedListHolder;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.sbhs.swm.dto.BookingDepositDto;

import com.sbhs.swm.dto.paging.BookingDepositListPagingDto;
import com.sbhs.swm.dto.request.LoginRequestDto;
import com.sbhs.swm.dto.request.SwmUserRequestDto;
import com.sbhs.swm.dto.response.BlocHomestayResponseDto;
import com.sbhs.swm.dto.response.BookingResponseDto;
import com.sbhs.swm.dto.response.LandlordCommissionResponseDto;
import com.sbhs.swm.dto.response.LandlordResponseDto;
import com.sbhs.swm.dto.response.LoginResponseDto;
import com.sbhs.swm.dto.response.PassengerResponseDto;
import com.sbhs.swm.dto.response.SwmUserResponseDto;
import com.sbhs.swm.models.Booking;
import com.sbhs.swm.models.BookingDeposit;
import com.sbhs.swm.models.Deposit;
import com.sbhs.swm.models.LandlordCommission;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.models.status.DepositStatus;
import com.sbhs.swm.security.JwtConfiguration;
import com.sbhs.swm.services.IUserService;

@RestController
@RequestMapping("/api/user")
public class UserController {

    @Autowired
    private IUserService userService;

    @Autowired
    private JwtConfiguration jwtConfig;

    @Autowired
    private ModelMapper modelMapper;

    @Autowired
    private SimpleDateFormat simpleDateFormat;

    @PostMapping("/registeration")
    public ResponseEntity<?> registerPassengerAccount(@RequestBody SwmUserRequestDto userDto) {
        SwmUser user = modelMapper.map(userDto, SwmUser.class);
        SwmUser savedUser = userService.registerPassengerAccount(user);
        SwmUserResponseDto responseUser = modelMapper.map(savedUser, SwmUserResponseDto.class);
        responseUser.setRoleIds(savedUser.getRoles().stream().map(r -> r.getId()).collect(Collectors.toList()));

        return new ResponseEntity<SwmUserResponseDto>(responseUser, HttpStatus.CREATED);
    }

    @PostMapping("/registration-landlord")
    public ResponseEntity<?> registerLandlordAccount(@RequestBody SwmUserRequestDto userDto, @RequestParam String front,
            @RequestParam String back) {
        SwmUser user = modelMapper.map(userDto, SwmUser.class);
        SwmUser savedUser = userService.registerLandlordAccount(user, front, back);
        SwmUserResponseDto responseUser = modelMapper.map(savedUser, SwmUserResponseDto.class);
        responseUser.setRoleIds(savedUser.getRoles().stream().map(r -> r.getId()).collect(Collectors.toList()));

        return new ResponseEntity<SwmUserResponseDto>(responseUser, HttpStatus.CREATED);
    }

    @GetMapping("/booking-deposits")
    @PreAuthorize("hasRole('ROLE_PASSENGER')")
    public ResponseEntity<?> getUserDeposits(int page, int size, boolean isNextPage, boolean isPreviousPage) {
        PagedListHolder<BookingDeposit> pagedListHolder = userService.getUserBookingDeposit(page, size, isNextPage,
                isPreviousPage);
        List<BookingDepositDto> responseBookingDepositList = pagedListHolder.getPageList().stream()
                .map(d -> modelMapper.map(d, BookingDepositDto.class)).collect(Collectors.toList());
        BookingDepositListPagingDto responseDepositListPaging = new BookingDepositListPagingDto();
        responseDepositListPaging.setBookingDeposits(responseBookingDepositList);
        responseDepositListPaging.setPageNumber(pagedListHolder.getPage());
        responseDepositListPaging.setTotalPage(pagedListHolder.getPageCount());

        return new ResponseEntity<BookingDepositListPagingDto>(responseDepositListPaging, HttpStatus.OK);
    }

    @GetMapping("/info")
    public ResponseEntity<?> getUserInfo(String username) {
        SwmUser user = userService.findUserByUsername(username);
        SwmUserResponseDto responseUser = modelMapper.map(user, SwmUserResponseDto.class);
        if (user.getPassengerProperty() != null) {
            for (Booking b : user.getPassengerProperty().getBookings()) {
                for (BookingResponseDto bResponse : responseUser.getPassengerProperty().getBookings()) {
                    if (b.getId() == bResponse.getId()) {
                        if (b.getBloc() != null) {
                            BlocHomestayResponseDto responseBloc = modelMapper.map(b.getBloc(),
                                    BlocHomestayResponseDto.class);
                            bResponse.setBlocResponse(responseBloc);
                        }
                    }
                }
            }
            if (user.getPassengerProperty().getBalanceWallet().getPassengerWallet().getDeposits() != null) {
                Long unpaidDeposit = 0L;
                Long userCurrentBalance = user.getPassengerProperty().getBalanceWallet().getTotalBalance();
                for (Deposit d : user.getPassengerProperty().getBalanceWallet().getPassengerWallet().getDeposits()) {
                    for (BookingDeposit bd : d.getBookingDeposits()) {
                        if (bd.getStatus().equalsIgnoreCase(DepositStatus.UNPAID.name())) {
                            unpaidDeposit = unpaidDeposit + bd.getUnpaidAmount();
                        }
                    }
                }
                userCurrentBalance = userCurrentBalance - unpaidDeposit;
                responseUser.getPassengerProperty().getBalanceWallet().setActualBalance(userCurrentBalance);
            } else {
                Long userCurrentBalance = user.getPassengerProperty().getBalanceWallet().getTotalBalance();
                responseUser.getPassengerProperty().getBalanceWallet().setActualBalance(userCurrentBalance);
            }

        }
        user.getRoles().forEach(r -> {
            if (r.getName().equalsIgnoreCase("passenger")) {
                responseUser
                        .setPassengerProperty(modelMapper.map(user.getPassengerProperty(), PassengerResponseDto.class));
                Long actualPassengerWalletBalance = userService.getUserActualBalance(r.getName(), user);
                responseUser.getPassengerProperty().getBalanceWallet().setActualBalance(actualPassengerWalletBalance);
            } else if (r.getName().equalsIgnoreCase("landlord")) {
                responseUser
                        .setLandlordProperty(modelMapper.map(user.getLandlordProperty(), LandlordResponseDto.class));
                Long actualLandlordWalletBalance = userService.getUserActualBalance(r.getName(), user);
                responseUser.getLandlordProperty().getBalanceWallet().setActualBalance(actualLandlordWalletBalance);
            }
        });
        responseUser.setRoleIds(user.getRoles().stream().map(r -> r.getId()).collect(Collectors.toList()));

        return new ResponseEntity<SwmUserResponseDto>(responseUser, HttpStatus.OK);
    }

    @GetMapping("/email-validation")
    public ResponseEntity<?> validateEmail(@RequestParam(name = "email") String email) {
        boolean validateEmail = userService.validateEmail(email);
        if (validateEmail) {
            return new ResponseEntity<>(HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.CONFLICT);
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequestDto login) {
        SwmUser user = userService.login(login.getUsername(), login.getPassword());
        String token = jwtConfig.generateJwtString(user.getUsername());

        List<String> roles = user.getRoles().stream().map(r -> r.getName()).collect(Collectors.toList());
        LoginResponseDto response = new LoginResponseDto(user.getUsername(), user.getEmail(), token,
                simpleDateFormat.format(jwtConfig.expireDate()),
                roles);
        return new ResponseEntity<LoginResponseDto>(response, HttpStatus.OK);
    }

    @GetMapping("/google-login")
    public ResponseEntity<?> loginByGoogle(@RequestParam("email") String email) {
        SwmUser user = userService.loginByGoogle(email);
        String token = jwtConfig.generateJwtString(user.getUsername());
        LoginResponseDto loginResponseDto = new LoginResponseDto(user.getUsername(), user.getEmail(), token,
                simpleDateFormat.format(jwtConfig.expireDate()),
                user.getRoles().stream().map(r -> r.getName()).collect(Collectors.toList()));
        return new ResponseEntity<>(loginResponseDto, HttpStatus.OK);
    }

    @GetMapping("/otp-mail")
    public ResponseEntity<?> sendPasswordModificationOtp(@RequestParam String email) {
        userService.sendPasswordModificationOtpMail(email);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @GetMapping("/otp-verification")
    public ResponseEntity<?> verifyPasswordModifyOtp(@RequestParam String otp) {
        userService.verifyPasswordModificationByOtp(otp);
        return new ResponseEntity<>(HttpStatus.ACCEPTED);
    }

    @PutMapping("/password-modification")
    public ResponseEntity<?> passwordModification(@RequestBody String password, @RequestParam String email) {
        userService.changePassword(password, email);
        return new ResponseEntity<>(HttpStatus.ACCEPTED);
    }

    @GetMapping
    @PreAuthorize("hasRole('ROLE_LANDLORD')")
    public ResponseEntity<?> getCommissionList() {
        List<LandlordCommission> landlordCommissions = userService.getLandlordCommissionList();
        List<LandlordCommissionResponseDto> responseCommissions = landlordCommissions.stream()
                .map(c -> modelMapper.map(c, LandlordCommissionResponseDto.class)).collect(Collectors.toList());

        return new ResponseEntity<List<LandlordCommissionResponseDto>>(responseCommissions, HttpStatus.OK);
    }
}