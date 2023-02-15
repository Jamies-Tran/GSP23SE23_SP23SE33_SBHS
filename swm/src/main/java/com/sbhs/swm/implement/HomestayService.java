package com.sbhs.swm.implement;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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

}
