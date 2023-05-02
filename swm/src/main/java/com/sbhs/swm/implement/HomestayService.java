package com.sbhs.swm.implement;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.support.PagedListHolder;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.sbhs.swm.dto.request.FilterOption;
import com.sbhs.swm.handlers.exceptions.HomestayNameDuplicateException;
import com.sbhs.swm.handlers.exceptions.HomestayNotFoundException;
import com.sbhs.swm.handlers.exceptions.InvalidAccountOperatorException;
import com.sbhs.swm.handlers.exceptions.UsernameNotFoundException;
import com.sbhs.swm.models.BlocHomestay;
import com.sbhs.swm.models.Homestay;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.models.status.BookingStatus;
import com.sbhs.swm.models.status.HomestayStatus;
import com.sbhs.swm.models.status.LandlordStatus;
import com.sbhs.swm.repositories.BlocHomestayRepo;
import com.sbhs.swm.repositories.HomestayFacilityRepo;
import com.sbhs.swm.repositories.HomestayRepo;
import com.sbhs.swm.repositories.HomestayServiceRepo;
import com.sbhs.swm.services.IFilterBlocHomestayService;
import com.sbhs.swm.services.IFilterHomestayService;
import com.sbhs.swm.services.IGoongService;
import com.sbhs.swm.services.IHomestayService;
import com.sbhs.swm.services.IUserService;
import com.sbhs.swm.util.CityProvinceNameUtil;
import com.sbhs.swm.util.DateTimeUtil;

@Service
public class HomestayService implements IHomestayService {

    @Autowired
    private HomestayRepo homestayRepo;

    @Autowired
    private BlocHomestayRepo blocHomestayRepo;

    @Autowired
    private HomestayFacilityRepo homestayFacilityRepo;

    @Autowired
    private HomestayServiceRepo homestayServiceRepo;

    @Autowired
    private IUserService userService;

    @Autowired
    private DateTimeUtil dateFormatUtil;

    @Autowired
    private CityProvinceNameUtil cityProvinceNameUtil;

    @Autowired
    private IGoongService goongService;

    @Autowired
    private IFilterHomestayService filterHomestayService;

    @Autowired
    private IFilterBlocHomestayService filterBlocHomestayService;

    @Override
    public Homestay createHomestay(Homestay homestay) {

        SwmUser user = userService.authenticatedUser();
        if (user.getLandlordProperty() == null) {
            throw new UsernameNotFoundException(user.getUsername());
        } else if (!user.getLandlordProperty().getStatus().equals(LandlordStatus.ACTIVATING.name())) {
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
        addressBuilder.append("_").append(homestayGeometryAddress);

        homestay.setAddress(addressBuilder.toString());
        homestay.getHomestayRules().forEach(r -> r.setHomestay(homestay));
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
        } else if (!user.getLandlordProperty().getStatus().equals(LandlordStatus.ACTIVATING.name())) {
            throw new InvalidAccountOperatorException();
        } else if (blocHomestayRepo.findBlocHomestayByName(blocHomestay.getName()).isPresent()) {
            throw new HomestayNameDuplicateException();
        }
        String blocGeometryAddress = goongService.convertAddressToGeometry(blocHomestay.getAddress());
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
        addressBuilder.append("_").append(blocGeometryAddress);
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
            h.getHomestayFacilities().forEach(f -> f.setHomestay(h));
            h.setBloc(blocHomestay);
        });
        blocHomestay.getHomestayRules().forEach(r -> r.setBloc(blocHomestay));
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
    public PagedListHolder<Homestay> findHomestayList(String filterBy, int page, int size,
            boolean isNextPage,
            boolean isPreviousPage) {

        SwmUser user = userService.authenticatedUser();
        List<Homestay> homestayList = user.getLandlordProperty().getHomestays();
        homestayList = homestayList.stream().filter(h -> h.getStatus().equals(filterBy.toUpperCase()))
                .collect(Collectors.toList());
        PagedListHolder<Homestay> pagedListHolder = new PagedListHolder<>(homestayList);
        pagedListHolder.setPage(page);
        pagedListHolder.setPageSize(size);
        if (!pagedListHolder.isFirstPage() && isPreviousPage == true && isNextPage == false) {
            pagedListHolder.previousPage();
        } else if (!pagedListHolder.isLastPage() && isNextPage == true && isPreviousPage == false) {
            pagedListHolder.nextPage();
        }

        return pagedListHolder;
    }

    @Override
    public BlocHomestay findBlocHomestayByName(String name) {
        BlocHomestay bloc = blocHomestayRepo.findBlocHomestayByName(name)
                .orElseThrow(() -> new HomestayNotFoundException());

        return bloc;
    }

    @Override
    public PagedListHolder<BlocHomestay> findBlocHomestaysByStatus(String status, int page, int size,
            boolean isNextPage,
            boolean isPreviousPage) {

        List<BlocHomestay> blocHomestays = blocHomestayRepo.findBlocHomestaysByStatus(status);
        PagedListHolder<BlocHomestay> pagedListHolder = new PagedListHolder<>(blocHomestays);
        pagedListHolder.setPage(page);
        pagedListHolder.setPageSize(size);
        if (!pagedListHolder.isLastPage() && isNextPage == true && isPreviousPage == false) {
            pagedListHolder.nextPage();
        } else if (!pagedListHolder.isFirstPage() && isPreviousPage == true && isNextPage == false) {
            pagedListHolder.previousPage();
        }

        return pagedListHolder;
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
    public PagedListHolder<Homestay> getHomestayListFiltered(FilterOption filterOption, String searchString, int page,
            int size,
            boolean isNextPage,
            boolean isPreviousPage, String sortBy) {
        List<Homestay> homestays = homestayRepo.getAllAvailableHomestay();
        if (StringUtils.hasLength(searchString)) {
            homestays = filterHomestayService.filterBySearchString(homestays, searchString);

        }
        if (filterOption != null) {

            if (filterOption.getFilterByAddress() != null) {
                homestays = filterHomestayService.filterByAddress(homestays,
                        filterOption.getFilterByAddress().getAddress(),
                        filterOption.getFilterByAddress().getDistance(),

                        filterOption.getFilterByAddress().getIsGeometry());

            }
            if (filterOption.getFilterByBookingDateRange() != null) {
                homestays = filterHomestayService.filterByBookingDateRange(homestays,
                        filterOption.getFilterByBookingDateRange().getStart(),
                        filterOption.getFilterByBookingDateRange().getEnd(),
                        filterOption.getFilterByBookingDateRange().getTotalReservation());
            }
            if (filterOption.getFilterByFacility() != null) {
                homestays = filterHomestayService.filterByFacility(homestays,
                        filterOption.getFilterByFacility().getName(), filterOption.getFilterByFacility().getQuantity());
            }

            if (filterOption.getFilterByHomestayService() != null) {
                homestays = filterHomestayService.filterByHomestayService(homestays,
                        filterOption.getFilterByHomestayService().getName(),
                        filterOption.getFilterByHomestayService().getPrice());
            }
            if (filterOption.getFilterByPriceRange() != null) {
                homestays = filterHomestayService.filterByPriceRange(homestays,
                        filterOption.getFilterByPriceRange().getHighest(),
                        filterOption.getFilterByPriceRange().getLowest());
            }
            if (filterOption.getFilterByRatingRange() != null) {
                homestays = filterHomestayService.filterByRatingRange(homestays,
                        filterOption.getFilterByRatingRange().getHighest(),
                        filterOption.getFilterByRatingRange().getLowest());
            }
        }

        Collections.sort(homestays, new Comparator<Homestay>() {

            @Override
            public int compare(Homestay h1, Homestay h2) {
                switch (sortBy.toUpperCase()) {
                    case "BOOKINGS":
                        if (h1.getBookingHomestays().stream()
                                .filter(h -> !h.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name()))
                                .collect(Collectors.toList()).size() > h2.getBookingHomestays().stream()
                                        .filter(h -> !h.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name()))
                                        .collect(Collectors.toList()).size()) {
                            return -1;
                        } else if (h1.getBookingHomestays().stream()
                                .filter(h -> !h.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name()))
                                .collect(Collectors.toList()).size() < h2.getBookingHomestays().stream()
                                        .filter(h -> !h.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name()))
                                        .collect(Collectors.toList()).size()) {
                            return 1;
                        } else {
                            return 0;
                        }

                    case "CREATED DATE":

                        if (dateFormatUtil.differenceInDays(h1.getCreatedDate(),
                                dateFormatUtil.formatDateTimeNowToString()) > dateFormatUtil.differenceInDays(
                                        h2.getCreatedDate(), dateFormatUtil.formatDateTimeNowToString())) {
                            return -1;
                        } else if (dateFormatUtil.differenceInDays(h1.getCreatedDate(),
                                dateFormatUtil.formatDateTimeNowToString()) < dateFormatUtil.differenceInDays(
                                        h2.getCreatedDate(), dateFormatUtil.formatDateTimeNowToString())) {
                            return 1;
                        } else {
                            return 0;
                        }
                    case "RATING":
                        if (h1.getTotalAverageRating() > h2.getTotalAverageRating()) {
                            return 1;
                        } else if (h1.getTotalAverageRating() < h2.getTotalAverageRating()) {
                            return -1;
                        } else {
                            return 0;
                        }
                    case "CAPACITY":
                        int firstCap = h1.getAvailableRooms() * h1.getRoomCapacity();
                        int secondCap = h2.getAvailableRooms() * h2.getRoomCapacity();
                        if (firstCap > secondCap) {
                            return -1;
                        } else if (firstCap < secondCap) {
                            return 1;
                        } else {
                            return 0;
                        }
                    case "NAME":
                        return h1.getName().compareTo(h2.getName());
                    case "PRICE":
                        if (h1.getPrice() > h2.getPrice()) {
                            return 1;
                        } else if (h1.getPrice() < h2.getPrice()) {
                            return -1;
                        } else {
                            return 0;
                        }

                    default:
                        if (h1.getTotalAverageRating() > h2.getTotalAverageRating()) {
                            return 1;
                        } else if (h1.getTotalAverageRating() < h2.getTotalAverageRating()) {
                            return -1;
                        } else {
                            return 0;
                        }
                }
            }

        });

        PagedListHolder<Homestay> homestayPage = new PagedListHolder<>(homestays);
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

    @Override
    public List<String> getAllHomestayFacilityNames(String homestayType) {
        List<String> facilityNames = new ArrayList<>();
        switch (homestayType.toUpperCase()) {
            case "HOMESTAY":
                facilityNames = homestayFacilityRepo.getHomestayFacilityDistincNames();
                break;
            case "BLOC":
                facilityNames = homestayFacilityRepo.getBlocFacilityDistincNames();
                break;
        }
        return facilityNames;
    }

    @Override
    public List<String> getAllHomestayServiceNames(String homestayType) {
        List<String> serviceNames = new ArrayList<>();
        switch (homestayType.toUpperCase()) {
            case "HOMESTAY":
                serviceNames = homestayServiceRepo.findHomestayServiceDistincNames();
                break;
            case "BLOC":
                serviceNames = homestayServiceRepo.findBlocServiceDistincNames();
                break;
        }

        return serviceNames;

    }

    @Override
    public Long getHighestPriceOfHomestayService(String homestayType) {
        List<Long> servicePriceList = new ArrayList<>();
        switch (homestayType) {
            case "HOMESTAY":
                servicePriceList = homestayServiceRepo.findHomestayServiceOrderByPrice();
                break;
            case "BLOC":
                servicePriceList = homestayServiceRepo.findBlocServiceOrderByPrice();
                break;
        }

        if (!servicePriceList.isEmpty()) {
            return servicePriceList.get(0);
        } else {
            return 0L;
        }

    }

    @Override
    public Long getHighestPriceOfHomestay(String homestayType) {
        List<Long> homestayPriceList = new ArrayList<>();
        switch (homestayType.toUpperCase()) {
            case "HOMESTAY":
                homestayPriceList = homestayRepo.getHomestayOrderByPrice();
                break;
            case "BLOC":
                homestayPriceList = homestayRepo.getAllHomestayOrderByPrice();
                break;
        }
        if (!homestayPriceList.isEmpty()) {
            return homestayPriceList.get(0);
        } else {
            return 0L;
        }

    }

    @Override
    public PagedListHolder<BlocHomestay> getBlocListFiltered(FilterOption filterOption, String searchString, int page,
            int size,
            boolean isNextPage, boolean isPreviousPage, String sortBy) {
        List<BlocHomestay> blocs = blocHomestayRepo.getAllAvailableBlocs();
        if (StringUtils.hasLength(searchString)) {
            blocs = filterBlocHomestayService.filterBySearchString(blocs, searchString);
        }
        if (filterOption != null) {

            if (filterOption.getFilterByBookingDateRange() != null) {
                blocs = filterBlocHomestayService.filterBlocByBookingDateRange(blocs,
                        filterOption.getFilterByBookingDateRange().getStart(),
                        filterOption.getFilterByBookingDateRange().getEnd(),
                        filterOption.getFilterByBookingDateRange().getTotalReservation());
            }
            if (filterOption.getFilterByAddress() != null) {
                blocs = filterBlocHomestayService.filterByAddress(blocs, filterOption.getFilterByAddress().getAddress(),
                        filterOption.getFilterByAddress().getDistance(),
                        filterOption.getFilterByAddress().getIsGeometry());
            }
            if (filterOption.getFilterByFacility() != null) {
                blocs = filterBlocHomestayService.filterByFacility(blocs, filterOption.getFilterByFacility().getName(),
                        filterOption.getFilterByFacility().getQuantity());
            }
            if (filterOption.getFilterByHomestayService() != null) {
                blocs = filterBlocHomestayService.filterByBlocService(blocs,
                        filterOption.getFilterByHomestayService().getName(),
                        filterOption.getFilterByHomestayService().getPrice());
            }
            if (filterOption.getFilterByPriceRange() != null) {
                blocs = filterBlocHomestayService.filterByPriceRange(blocs,
                        filterOption.getFilterByPriceRange().getLowest(),
                        filterOption.getFilterByPriceRange().getHighest());
            }
            if (filterOption.getFilterByRatingRange() != null) {
                blocs = filterBlocHomestayService.filterByRatingRange(blocs,
                        filterOption.getFilterByRatingRange().getLowest(),
                        filterOption.getFilterByRatingRange().getHighest());
            }
        }
        Collections.sort(blocs, new Comparator<BlocHomestay>() {

            @Override
            public int compare(BlocHomestay h1, BlocHomestay h2) {
                switch (sortBy.toUpperCase()) {
                    case "BOOKING":
                        if (h1.getBookings().stream()
                                .filter(h -> !h.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name()))
                                .collect(Collectors.toList()).size() > h2.getBookings().stream()
                                        .filter(h -> !h.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name()))
                                        .collect(Collectors.toList()).size()) {
                            return -1;
                        } else if (h1.getBookings().stream()
                                .filter(h -> !h.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name()))
                                .collect(Collectors.toList()).size() < h2.getBookings().stream()
                                        .filter(h -> !h.getStatus().equalsIgnoreCase(BookingStatus.SAVED.name()))
                                        .collect(Collectors.toList()).size()) {
                            return 1;
                        } else {
                            return 0;
                        }

                    case "DATE":

                        if (dateFormatUtil.differenceInDays(h1.getCreatedDate(),
                                dateFormatUtil.formatDateTimeNowToString()) > dateFormatUtil.differenceInDays(
                                        h2.getCreatedDate(), dateFormatUtil.formatDateTimeNowToString())) {
                            return -1;
                        } else if (dateFormatUtil.differenceInDays(h1.getCreatedDate(),
                                dateFormatUtil.formatDateTimeNowToString()) < dateFormatUtil.differenceInDays(
                                        h2.getCreatedDate(), dateFormatUtil.formatDateTimeNowToString())) {
                            return 1;
                        } else {
                            return 0;
                        }
                    case "RATING":
                        if (h1.getTotalAverageRating() > h2.getTotalAverageRating()) {
                            return 1;
                        } else if (h1.getTotalAverageRating() < h2.getTotalAverageRating()) {
                            return -1;
                        } else {
                            return 0;
                        }
                    case "HOMESTAY":
                        int firstCap = h1.getHomestays().size();
                        int secondCap = h2.getHomestays().size();
                        if (firstCap > secondCap) {
                            return -1;
                        } else if (firstCap < secondCap) {
                            return 1;
                        } else {
                            return 0;
                        }
                    case "NAME":
                        return h1.getName().compareTo(h2.getName());
                    case "PRICE":
                        List<Homestay> firstHomestaysInBloc = h1.getHomestays().stream()
                                .sorted(new Comparator<Homestay>() {

                                    @Override
                                    public int compare(Homestay a1, Homestay a2) {
                                        if (a1.getPrice() > a2.getPrice()) {
                                            return 1;
                                        } else if (a1.getPrice() < a2.getPrice()) {
                                            return -1;
                                        } else {
                                            return 0;
                                        }
                                    }

                                }).collect(Collectors.toList());
                        List<Homestay> secondHomestaysInBloc = h2.getHomestays().stream()
                                .sorted(new Comparator<Homestay>() {

                                    @Override
                                    public int compare(Homestay a1, Homestay a2) {
                                        if (a1.getPrice() > a2.getPrice()) {
                                            return 1;
                                        } else if (a1.getPrice() < a2.getPrice()) {
                                            return -1;
                                        } else {
                                            return 0;
                                        }
                                    }

                                }).collect(Collectors.toList());
                        if (firstHomestaysInBloc.get(0).getPrice() > secondHomestaysInBloc.get(0).getPrice()) {
                            return 1;
                        } else if (firstHomestaysInBloc.get(0).getPrice() < secondHomestaysInBloc.get(0).getPrice()) {
                            return -1;
                        } else {
                            return 0;
                        }

                    default:
                        if (h1.getTotalAverageRating() > h2.getTotalAverageRating()) {
                            return 1;
                        } else if (h1.getTotalAverageRating() < h2.getTotalAverageRating()) {
                            return -1;
                        } else {
                            return 0;
                        }
                }
            }

        });
        PagedListHolder<BlocHomestay> pagedListHolder = new PagedListHolder<>(blocs);
        if (pagedListHolder.isLastPage() == false && isNextPage == true && isPreviousPage == false) {
            pagedListHolder.nextPage();
        } else if (pagedListHolder.isFirstPage() == false && isPreviousPage == true && isNextPage == false) {
            pagedListHolder.previousPage();
        }

        return pagedListHolder;
    }

    @Override
    public PagedListHolder<BlocHomestay> findBlocList(String filterBy, int page, int size,
            boolean isNextPage, boolean isPreviousPage) {
        SwmUser user = userService.authenticatedUser();
        List<BlocHomestay> blocHomestayList = user.getLandlordProperty().getBlocHomestays();
        blocHomestayList = blocHomestayList.stream().filter(b -> b.getStatus().equals(filterBy.toUpperCase()))
                .collect(Collectors.toList());
        PagedListHolder<BlocHomestay> pagedListHolder = new PagedListHolder<>(blocHomestayList);
        pagedListHolder.setPage(page);
        pagedListHolder.setPageSize(size);
        if (!pagedListHolder.isLastPage() && isPreviousPage == true && isNextPage == false) {
            pagedListHolder.previousPage();
        } else if (!pagedListHolder.isLastPage() && isNextPage == true && isPreviousPage == false) {
            pagedListHolder.nextPage();
        }

        return pagedListHolder;
    }

    @Override
    public PagedListHolder<Homestay> findHomestaysByStatus(String status, int page, int size, boolean isNextPage,
            boolean isPreviousPage) {
        List<Homestay> homestayList = homestayRepo.findHomestayByStatus(status);
        PagedListHolder<Homestay> pagedListHolder = new PagedListHolder<>(homestayList);

        if (!pagedListHolder.isFirstPage() && isPreviousPage == true && isNextPage == false) {
            pagedListHolder.previousPage();
        } else if (!pagedListHolder.isLastPage() && isNextPage == true && isPreviousPage == false) {
            pagedListHolder.nextPage();
        }

        return pagedListHolder;
    }

    @Override
    public Integer getHomestayNumberOfReview(String homestayName) {
        Homestay homestay = this.findHomestayByName(homestayName);

        return homestay.getRatings().size();
    }

    @Override
    public Integer getBlocHomestayNumberOfReview(String blocName) {
        BlocHomestay bloc = this.findBlocHomestayByName(blocName);

        return bloc.getRatings().size();
    }

}
