package com.sbhs.swm.implement;

import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.support.PagedListHolder;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.sbhs.swm.dto.goong.DistanceElement;
import com.sbhs.swm.dto.goong.DistanceResultRows;
import com.sbhs.swm.handlers.exceptions.HomestayNameDuplicateException;
import com.sbhs.swm.handlers.exceptions.HomestayNotFoundException;
import com.sbhs.swm.handlers.exceptions.InvalidAccountOperatorException;
import com.sbhs.swm.handlers.exceptions.InvalidException;
import com.sbhs.swm.handlers.exceptions.UsernameNotFoundException;
import com.sbhs.swm.models.BlocHomestay;
import com.sbhs.swm.models.Homestay;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.models.status.HomestayStatus;
import com.sbhs.swm.models.status.LandlordStatus;
import com.sbhs.swm.repositories.BlocHomestayRepo;
import com.sbhs.swm.repositories.HomestayRepo;
import com.sbhs.swm.services.IGoongService;
import com.sbhs.swm.services.IHomestayService;
import com.sbhs.swm.services.IUserService;
import com.sbhs.swm.util.CityProvinceNameUtil;
import com.sbhs.swm.util.DateFormatUtil;

@Service
public class HomestayService implements IHomestayService {

    @Autowired
    private HomestayRepo homestayRepo;

    @Autowired
    private BlocHomestayRepo blocHomestayRepo;

    @Autowired
    private IUserService userService;

    @Autowired
    private DateFormatUtil dateFormatUtil;

    @Autowired
    private CityProvinceNameUtil cityProvinceNameUtil;

    @Autowired
    private IGoongService goongService;

    @Override
    public Homestay createHomestay(Homestay homestay) {

        SwmUser user = userService.authenticatedUser();
        if (user.getLandlordProperty() == null) {
            throw new UsernameNotFoundException(user.getUsername());
        } else if (!user.getLandlordProperty().getStatus().equals(LandlordStatus.ACTIVATED.name())) {
            throw new InvalidAccountOperatorException();
        } else if (homestayRepo.findHomestayByName(homestay.getName()).isPresent()) {
            throw new HomestayNameDuplicateException();
        }
        String homestayGeometryAddress = goongService.convertAddressToGeometry(homestay.getAddress());
        List<String> splittedAddress = new LinkedList<String>(List.of(homestay.getAddress().split(",")));
        String city = splittedAddress.get(homestay.getAddress().split(",").length - 1);
        homestay.setCityProvince(
                cityProvinceNameUtil.shortenCityName(city.trim()));
        splittedAddress.remove(city);
        StringBuilder addressBuilder = new StringBuilder();
        for (int addressIndex = 0; addressIndex < splittedAddress.size(); addressIndex++) {
            if (addressIndex == splittedAddress.size() - 1) {
                addressBuilder.append(splittedAddress.get(addressIndex));
            } else {
                addressBuilder.append(splittedAddress.get(addressIndex)).append(",");
            }

        }
        addressBuilder.append("-").append(homestayGeometryAddress);
        homestay.setAddress(addressBuilder.toString());
        homestay.setStatus(HomestayStatus.PENDING.name());
        homestay.setLandlord(user.getLandlordProperty());
        homestay.getHomestayServices().forEach(h -> h.setHomestay(homestay));
        homestay.getHomestayImages().forEach(i -> i.setHomestay(homestay));
        homestay.getHomestayFacilities().forEach(f -> f.setHomestay(homestay));
        homestay.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
        homestay.setCreatedBy(user.getUsername());

        user.getLandlordProperty().setHomestays(List.of(homestay));
        Homestay savedHomestay = homestayRepo.save(homestay);

        return savedHomestay;
    }

    @Override
    public BlocHomestay createBlocHomestay(BlocHomestay blocHomestay) {
        SwmUser user = userService.authenticatedUser();
        if (user.getLandlordProperty() == null) {
            throw new UsernameNotFoundException(user.getUsername());
        } else if (!user.getLandlordProperty().getStatus().equals(LandlordStatus.ACTIVATED.name())) {
            throw new InvalidAccountOperatorException();
        } else if (blocHomestayRepo.findBlocHomestayByName(blocHomestay.getName()).isPresent()) {
            throw new HomestayNameDuplicateException();
        }

        List<String> splittedAddress = new LinkedList<String>(List.of(blocHomestay.getAddress().split(",")));
        String city = splittedAddress.get(blocHomestay.getAddress().split(",").length - 1);
        blocHomestay.setCityProvince(
                cityProvinceNameUtil.shortenCityName(city.trim()));
        splittedAddress.remove(city);
        StringBuilder addressBuilder = new StringBuilder();
        for (int addressIndex = 0; addressIndex < splittedAddress.size(); addressIndex++) {
            if (addressIndex == splittedAddress.size() - 1) {
                addressBuilder.append(splittedAddress.get(addressIndex));
            } else {
                addressBuilder.append(splittedAddress.get(addressIndex)).append(",");
            }

        }
        blocHomestay.setAddress(addressBuilder.toString());
        blocHomestay.setLandlord(user.getLandlordProperty());
        blocHomestay.setStatus(HomestayStatus.PENDING.name());
        blocHomestay.getHomestayServices().forEach(s -> s.setBloc(blocHomestay));
        blocHomestay.getHomestays().forEach(h -> {
            h.setAddress(blocHomestay.getAddress());
            h.setCityProvince(blocHomestay.getCityProvince());
            h.setBusinessLicense(blocHomestay.getBusinessLicense());
            h.setHomestayServices(blocHomestay.getHomestayServices());
            h.setLandlord(user.getLandlordProperty());
            h.setStatus(blocHomestay.getStatus());
            h.getHomestayImages().forEach(i -> i.setHomestay(h));
            h.setBloc(blocHomestay);
        });
        blocHomestay.setCreatedDate(dateFormatUtil.formatDateTimeNowToString());
        blocHomestay.setCreatedBy(user.getUsername());

        BlocHomestay savedBlocHomestay = blocHomestayRepo.save(blocHomestay);

        return savedBlocHomestay;
    }

    @Override
    public Homestay findHomestayByName(String name) {
        Homestay homestay = homestayRepo.findHomestayByName(name).orElseThrow(() -> new HomestayNotFoundException());

        return homestay;
    }

    @Override
    public Page<Homestay> findHomestayList(String filter, String name, int page, int size, boolean isNextPage,
            boolean isPreviousPage) {

        Pageable pageable = PageRequest.of(page, size);
        Page<Homestay> homestayPage;
        // custom page
        // homestayPage = new PageImpl<>();
        switch (filter.toUpperCase()) {
            case "HOMESTAY_STATUS":
                homestayPage = homestayRepo.findHomestaysByStatus(pageable, name);

                if (isNextPage == true && isPreviousPage == false && homestayPage.hasNext()) {
                    homestayPage = homestayRepo.findHomestaysByStatus(homestayPage.nextPageable(), name);
                } else if (isNextPage == false && isPreviousPage == true && homestayPage.hasPrevious()) {
                    homestayPage = homestayRepo.findHomestaysByStatus(homestayPage.previousPageable(), name);
                }
                break;
            case "Homestay_OWNER":
                homestayPage = homestayRepo.findHomestaysByLandlordName(pageable, name);
                if (isNextPage == true && isPreviousPage == false && homestayPage.hasNext()) {
                    homestayPage = homestayRepo.findHomestaysByLandlordName(homestayPage.nextPageable(), name);
                } else if (isNextPage == false && isPreviousPage == true && homestayPage.hasPrevious()) {
                    homestayPage = homestayRepo.findHomestaysByLandlordName(homestayPage.previousPageable(), name);
                }
                break;
            case "HOMESTAY_BLOC":
                homestayPage = homestayRepo.findHomestayByBlocName(pageable, name);
                if (isNextPage == true && isPreviousPage == false && homestayPage.hasNext()) {
                    homestayPage = homestayRepo.findHomestayByBlocName(homestayPage.nextPageable(), name);
                } else if (isNextPage == false && isPreviousPage == true && homestayPage.hasPrevious()) {
                    homestayPage = homestayRepo.findHomestayByBlocName(homestayPage.previousPageable(), name);
                }
                break;
            default:
                throw new InvalidException("Invalid filter");
        }
        return homestayPage;
    }

    @Override
    public BlocHomestay findBlocHomestayByName(String name) {
        BlocHomestay bloc = blocHomestayRepo.findBlocHomestayByName(name)
                .orElseThrow(() -> new HomestayNotFoundException());

        return bloc;
    }

    @Override
    public Page<BlocHomestay> findBlocHomestaysByStatus(String status, int page, int size, boolean isNextPage,
            boolean isPreviousPage) {
        Pageable pageable = PageRequest.of(page, size);
        Page<BlocHomestay> blocHomestays = blocHomestayRepo.findBlocHomestaysByStatus(pageable, status);
        if (blocHomestays.hasNext() && isNextPage == true && isPreviousPage == false) {
            blocHomestays = blocHomestayRepo.findBlocHomestaysByStatus(blocHomestays.nextPageable(), status);
        } else if (blocHomestays.hasPrevious() && isPreviousPage == true && isNextPage == false) {
            blocHomestays = blocHomestayRepo.findBlocHomestaysByStatus(blocHomestays.previousPageable(), status);
        }

        return blocHomestays;
    }

    @Override
    public List<String> getHomestayCityOrProvince() {
        List<String> cityOrProvinceList = homestayRepo.getHomestayCityOrProvince();

        return cityOrProvinceList;
    }

    @Override
    public Integer getTotalHomestayOnLocation(String location) {
        Integer totalHomestayOnLocation = homestayRepo.getTotalHomestayOnLocation(location);

        return totalHomestayOnLocation;
    }

    @Override
    public List<String> getBlocCityOrProvince() {
        List<String> cityOrProvinceList = homestayRepo.getBlocCityOrProvince();

        return cityOrProvinceList;
    }

    @Override
    public Integer getTotalBlocOnLocation(String location) {
        Integer totalBloc = homestayRepo.getTotalBlocOnLocation(location);

        return totalBloc;
    }

    @Override
    public Page<Homestay> getHomestayListOrderByTotalAverageRatingPoint(int page, int size, boolean isNextPage,
            boolean isPreviousPage) {
        Pageable pageable = PageRequest.of(page, size);
        Page<Homestay> homestays = homestayRepo.getHomestayListOrderByTotalAverageRatingPoint(pageable);
        if (homestays.hasNext() && isNextPage == true && isPreviousPage == false) {
            homestays = homestayRepo.getHomestayListOrderByTotalAverageRatingPoint(homestays.nextPageable());
        } else if (homestays.hasPrevious() && isPreviousPage == true && isPreviousPage == false) {
            homestays = homestayRepo.getHomestayListOrderByTotalAverageRatingPoint(homestays.previousPageable());
        }

        return homestays;
    }

    @Override
    public Page<BlocHomestay> getBlocListOrderByTotalAverageRatingPoint(int page, int size, boolean isNextPage,
            boolean isPreviousPage) {
        Pageable pageable = PageRequest.of(page, size);
        Page<BlocHomestay> blocs = blocHomestayRepo.getBlocListOrderByTotalAverageRatingPoint(pageable);
        if (blocs.hasNext() && isNextPage == true && isPreviousPage == false) {
            blocs = blocHomestayRepo.getBlocListOrderByTotalAverageRatingPoint(blocs.nextPageable());
        } else if (blocs.hasPrevious() && isPreviousPage == true && isNextPage == false) {
            blocs = blocHomestayRepo.getBlocListOrderByTotalAverageRatingPoint(blocs.previousPageable());
        }

        return blocs;
    }

    @Override
    public PagedListHolder<Homestay> getHomestayListNearByLocation(String address, int page, int size,
            boolean isNextPage,
            boolean isPreviousPage,
            boolean isGeometry) {
        List<Homestay> homestays = homestayRepo.findAll();
        List<String> destinations = homestays.stream().map(h -> h.getAddress())
                .collect(Collectors.toList());
        DistanceResultRows distanceResultRows = goongService.getDistanceFromLocation(address, destinations, isGeometry);
        List<DistanceElement> addressesSorted = distanceResultRows.getRows().get(0).getElements().stream()
                .sorted(Collections.reverseOrder())
                .collect(Collectors.toList());
        List<Homestay> homestaySortedList = addressesSorted.stream()
                .map(a -> this.findHomestayByAddress(a.getAddress())).collect(Collectors.toList());
        PagedListHolder<Homestay> homestayPage = new PagedListHolder<>(homestaySortedList);
        homestayPage.setPage(page);
        homestayPage.setPageSize(size);
        if (homestayPage.isLastPage() == false && isNextPage == true && isPreviousPage == false) {
            homestayPage.nextPage();
        } else if (homestayPage.isFirstPage() == false && isPreviousPage == true && isNextPage == false) {
            homestayPage.previousPage();
        }

        return homestayPage;
    }

    @Override
    public Homestay findHomestayByAddress(String address) {
        Homestay homestay = homestayRepo.findHomestayByAddress(address)
                .orElseThrow(() -> new HomestayNotFoundException());

        return homestay;
    }

}
