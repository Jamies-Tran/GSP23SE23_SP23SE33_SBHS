package com.sbhs.swm.implement;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.sbhs.swm.handlers.exceptions.HomestayNameDuplicateException;
import com.sbhs.swm.handlers.exceptions.HomestayNotFoundException;
import com.sbhs.swm.handlers.exceptions.InvalidException;
import com.sbhs.swm.handlers.exceptions.UsernameNotFoundException;
import com.sbhs.swm.models.BlocHomestay;
import com.sbhs.swm.models.Homestay;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.models.status.HomestayStatus;
import com.sbhs.swm.repositories.BlocHomestayRepo;
import com.sbhs.swm.repositories.HomestayRepo;
import com.sbhs.swm.services.IHomestayService;
import com.sbhs.swm.services.IUserService;

@Service
public class HomestayService implements IHomestayService {

    @Autowired
    private HomestayRepo homestayRepo;

    @Autowired
    private BlocHomestayRepo blocHomestayRepo;

    @Autowired
    private IUserService userService;

    @Override
    public Homestay createHomestay(Homestay homestay) {
        SwmUser user = userService.authenticatedUser();
        if (user.getLandlordProperty() == null) {
            throw new UsernameNotFoundException(user.getUsername());
        } else if (homestayRepo.findHomestayByName(homestay.getName()).isPresent()) {
            throw new HomestayNameDuplicateException();
        }
        homestay.setStatus(HomestayStatus.PENDING.name());
        homestay.setLandlord(user.getLandlordProperty());
        homestay.getHomestayServices().forEach(h -> h.setHomestay(homestay));
        homestay.getHomestayImages().forEach(i -> i.setHomestay(homestay));
        homestay.getHomestayFacilities().forEach(f -> f.setHomestay(homestay));

        user.getLandlordProperty().setHomestays(List.of(homestay));
        Homestay savedHomestay = homestayRepo.save(homestay);

        return savedHomestay;
    }

    @Override
    public BlocHomestay createBlocHomestay(BlocHomestay blocHomestay) {
        SwmUser user = userService.authenticatedUser();
        if (user.getLandlordProperty() == null) {
            throw new UsernameNotFoundException(user.getUsername());
        }
        blocHomestay.setLandlord(user.getLandlordProperty());
        blocHomestay.setStatus(HomestayStatus.PENDING.name());
        blocHomestay.getHomestayServices().forEach(s -> s.setBloc(blocHomestay));
        blocHomestay.getHomestays().forEach(h -> {
            h.setAddress(blocHomestay.getAddress());
            h.setBusinessLicense(blocHomestay.getBusinessLicense());
            h.setHomestayServices(blocHomestay.getHomestayServices());
            h.setLandlord(user.getLandlordProperty());
            h.setStatus(blocHomestay.getStatus());
            h.setBloc(blocHomestay);
        });

        BlocHomestay savedBlocHomestay = blocHomestayRepo.save(blocHomestay);

        return savedBlocHomestay;
    }

    @Override
    public Homestay findHomestayByName(String name) {
        Homestay homestay = homestayRepo.findHomestayByName(name).orElseThrow(() -> new HomestayNotFoundException());

        return homestay;
    }

    // @Override
    // public List<Homestay> findHomestayByStatus(String status, int page, int size,
    // boolean isNextPage) {
    // Pageable pageable = PageRequest.of(page, size);
    // Page<Homestay> homestays = homestayRepo.findHomestaysByStatus(pageable,
    // status);
    // if (isNextPage == true && homestays.hasNext()) {
    // homestays = homestayRepo.findHomestaysByStatus(homestays.nextPageable(),
    // status);
    // }

    // return homestays.getContent();
    // }

    // @Override
    // public List<Homestay> findHomestaysByLandlordName(String name, int page, int
    // size) {
    // Pageable pageable = PageRequest.of(page, size);
    // Page<Homestay> homestays = homestayRepo.findHomestaysByLandlordName(pageable,
    // name);

    // return homestays.getContent();
    // }

    // @Override
    // public List<Homestay> findHomestaysByBlocName(String blocName, int page, int
    // size) {
    // Pageable pageable = PageRequest.of(page, size);
    // Page<Homestay> homestays = homestayRepo.findHomestayByBlocName(pageable,
    // blocName);

    // return homestays.getContent();
    // }

    @Override
    public Page<Homestay> findHomestayList(String filter, String param, int page, int size, boolean isNextPage,
            boolean isPreviousPage) {

        Pageable pageable = PageRequest.of(page, size);
        Page<Homestay> homestayPage;
        // custom page
        // homestayPage = new PageImpl<>();
        switch (filter.toUpperCase()) {
            case "HOMESTAY_STATUS":
                homestayPage = homestayRepo.findHomestaysByStatus(pageable, param);

                if (isNextPage == true && isPreviousPage == false && homestayPage.hasNext()) {
                    homestayPage = homestayRepo.findHomestaysByStatus(homestayPage.nextPageable(), param);
                } else if (isNextPage == false && isPreviousPage == true && homestayPage.hasPrevious()) {
                    homestayPage = homestayRepo.findHomestaysByStatus(homestayPage.previousPageable(), param);
                }
                break;
            case "Homestay_OWNER":
                homestayPage = homestayRepo.findHomestaysByLandlordName(pageable, param);
                if (isNextPage == true && isPreviousPage == false && homestayPage.hasNext()) {
                    homestayPage = homestayRepo.findHomestaysByLandlordName(homestayPage.nextPageable(), param);
                } else if (isNextPage == false && isPreviousPage == true && homestayPage.hasPrevious()) {
                    homestayPage = homestayRepo.findHomestaysByLandlordName(homestayPage.previousPageable(), param);
                }
                break;
            case "HOMESTAY_BLOC":
                homestayPage = homestayRepo.findHomestayByBlocName(pageable, param);
                if (isNextPage == true && isPreviousPage == false && homestayPage.hasNext()) {
                    homestayPage = homestayRepo.findHomestayByBlocName(homestayPage.nextPageable(), param);
                } else if (isNextPage == false && isPreviousPage == true && homestayPage.hasPrevious()) {
                    homestayPage = homestayRepo.findHomestayByBlocName(homestayPage.previousPageable(), param);
                }
                break;
            default:
                throw new InvalidException("Invalid filter");
        }
        return homestayPage;
    }

}
