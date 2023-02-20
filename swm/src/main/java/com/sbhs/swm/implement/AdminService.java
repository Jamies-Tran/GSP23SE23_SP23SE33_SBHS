package com.sbhs.swm.implement;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
// import org.springframework.data.domain.Sort;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.sbhs.swm.handlers.exceptions.EmailDuplicateException;
import com.sbhs.swm.handlers.exceptions.InvalidException;
import com.sbhs.swm.handlers.exceptions.PhoneDuplicateException;
import com.sbhs.swm.handlers.exceptions.RoleNotFoundException;
import com.sbhs.swm.handlers.exceptions.UsernameDuplicateException;
import com.sbhs.swm.handlers.exceptions.UsernameNotFoundException;
import com.sbhs.swm.models.Admin;
import com.sbhs.swm.models.BlocHomestay;
import com.sbhs.swm.models.Homestay;
import com.sbhs.swm.models.SwmRole;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.models.status.HomestayStatus;
import com.sbhs.swm.models.status.LandlordStatus;
import com.sbhs.swm.repositories.RoleRepo;
import com.sbhs.swm.repositories.UserRepo;
import com.sbhs.swm.services.IAdminService;
import com.sbhs.swm.services.IHomestayService;
import com.sbhs.swm.services.IMailService;

@Service
public class AdminService implements IAdminService {

    @Value("${admin.username}")
    private String USERNAME;

    @Value("${admin.password}")
    private String PASSWORD;

    @Value("${admin.avatarUrl}")
    private String AVATARURL;

    @Value("${admin.email}")
    private String EMAIL;

    @Value("${admin.phone}")
    private String PHONE;

    @Value("${admin.idCardNumber}")
    private String IDCARDNUMBER;

    @Value("${admin.address}")
    private String ADDRESS;

    @Value("${admin.dob}")
    private String DOB;

    @Value("${admin.gender}")
    private String GENDER;

    @Autowired
    private UserRepo userRepo;

    @Autowired
    private IHomestayService homestayService;

    @Autowired
    private IMailService mailService;

    @Autowired
    private RoleRepo roleRepo;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public SwmUser createAdminAccount(SwmUser user) {
        if (userRepo.findByUsername(user.getUsername()).isPresent()) {
            throw new UsernameDuplicateException();
        } else if (userRepo.findByEmail(user.getEmail()).isPresent()) {
            throw new EmailDuplicateException();
        } else if (userRepo.findByPhone(user.getPhone()).isPresent()) {
            throw new PhoneDuplicateException();
        }
        SwmRole adminRole = roleRepo.findByName("admin").orElseThrow(() -> new RoleNotFoundException());
        adminRole.setUsers(List.of(user));
        user.setRoles(List.of(adminRole));
        Admin admin = new Admin();
        admin.setUser(user);
        user.setAdminProperty(admin);
        SwmUser savedUser = userRepo.save(user);

        return savedUser;
    }

    @Override
    public SwmUser createFirstAdminAccount() {
        SwmUser user = new SwmUser();
        SwmRole adminRole = roleRepo.findByName("admin").orElseThrow(() -> new RoleNotFoundException());
        adminRole.setUsers(List.of(user));

        Admin admin = new Admin();
        user.setUsername(USERNAME);
        user.setPassword(passwordEncoder.encode(PASSWORD));
        user.setEmail(EMAIL);
        user.setPhone(PHONE);
        user.setIdCardNumber(IDCARDNUMBER);
        user.setAddress(ADDRESS);
        user.setDob(DOB);
        user.setGender(GENDER);
        user.setAvatarUrl(AVATARURL);
        user.setRoles(List.of(adminRole));
        user.setAdminProperty(admin);
        admin.setUser(user);
        SwmUser savedUser = userRepo.save(user);

        return savedUser;
    }

    @Override
    public Page<SwmUser> findLandlordListFilterByStatus(String status, int page, int size, boolean isNextPage,
            boolean isPreviousPage) {
        Page<SwmUser> userPage = userRepo.findLandlordListFilterByStatus(PageRequest.of(page, size), status);
        if (userPage.hasNext() && isNextPage == true && isPreviousPage == false) {
            userPage = userRepo.findLandlordListFilterByStatus(userPage.nextPageable(), status);
        } else if (userPage.hasPrevious() && isPreviousPage == true && isNextPage == false) {
            userPage = userRepo.findLandlordListFilterByStatus(userPage.previousPageable(), status);
        }

        return userPage;
    }

    @Override
    @Transactional
    public SwmUser activateLandlordAccount(String username) {
        SwmUser user = userRepo.findLandlordByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException(username));
        if (user.getLandlordProperty().getStatus().equalsIgnoreCase(LandlordStatus.ACTIVATED.name())) {
            throw new InvalidException("Landlord account has already been activated");
        }
        user.getLandlordProperty().setStatus(LandlordStatus.ACTIVATED.name());
        mailService.approveLandlordAccount(user);

        return user;
    }

    @Override
    @Transactional
    public Homestay activateHomestay(String name) {
        Homestay homestay = homestayService.findHomestayByName(name);
        if (homestay.getBloc() != null) {
            throw new InvalidException("Homestay in bloc ".concat(homestay.getBloc().getName()));
        }
        homestay.setStatus(HomestayStatus.ACTIVE.name());
        mailService.approveHomestay(homestay, null);

        return homestay;
    }

    @Override
    @Transactional
    public SwmUser rejectLandlordAccount(String username, String reason) {
        SwmUser user = userRepo.findLandlordByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException(username));
        switch (reason.toUpperCase()) {
            case "NOT_MATCHED":
                user.getLandlordProperty().setStatus(LandlordStatus.REJECTED_ID_NUMBER_NOT_MATCHED_IMAGE.name());
                break;
            case "FRONT_IMAGE":
                user.getLandlordProperty().setStatus(LandlordStatus.REJECTED_ID_FRONT_IMAGE.name());
                break;
            case "BACK_IMAGE":
                user.getLandlordProperty().setStatus(LandlordStatus.REJECTED_ID_BACK_IMAGE.name());
                break;
        }
        mailService.rejectLandlordAccount(user);

        return user;
    }

    @Override
    @Transactional
    public BlocHomestay activateBlocHomestay(String name) {
        BlocHomestay bloc = homestayService.findBlocHomestayByName(name);
        bloc.setStatus(HomestayStatus.ACTIVE.name());
        bloc.getHomestays().forEach(h -> h.setStatus(HomestayStatus.ACTIVE.name()));
        mailService.approveHomestay(null, bloc);

        return bloc;
    }

    @Override
    @Transactional
    public Homestay rejectHomestay(String name) {
        Homestay homestay = homestayService.findHomestayByName(name);
        if (homestay.getBloc() != null) {
            throw new InvalidException("Homestay in bloc ".concat(homestay.getBloc().getName()));
        }
        homestay.setStatus(HomestayStatus.REJECTED_LICENSE_NOT_MATCHED.name());
        mailService.rejectHomestay(homestay, null);

        return homestay;
    }

    @Override
    @Transactional
    public BlocHomestay rejectBloc(String name) {
        BlocHomestay bloc = homestayService.findBlocHomestayByName(name);
        bloc.setStatus(HomestayStatus.REJECTED_LICENSE_NOT_MATCHED.name());
        mailService.rejectHomestay(null, bloc);

        return bloc;
    }
}
