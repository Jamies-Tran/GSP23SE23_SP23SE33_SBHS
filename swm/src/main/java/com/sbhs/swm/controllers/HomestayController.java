package com.sbhs.swm.controllers;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.support.PagedListHolder;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.sbhs.swm.dto.paging.BlocHomestayListPagingDto;
import com.sbhs.swm.dto.paging.HomestayListPagingDto;
import com.sbhs.swm.dto.request.BlocHomestayRequestDto;
import com.sbhs.swm.dto.request.HomestayRequestDto;
import com.sbhs.swm.dto.request.HomestaySearchFilter;
import com.sbhs.swm.dto.response.BlocHomestayResponseDto;
import com.sbhs.swm.dto.response.FilterAdditionalResponseDto;
import com.sbhs.swm.dto.response.HomestayResponseDto;
import com.sbhs.swm.dto.response.TotalBlocFromCityProvinceResponseDto;
import com.sbhs.swm.dto.response.TotalHomestayFromCityProvinceResponseDto;
import com.sbhs.swm.dto.response.TotalHomestayFromLocationResponseDto;
import com.sbhs.swm.models.BlocHomestay;
import com.sbhs.swm.models.Homestay;
import com.sbhs.swm.services.IHomestayService;

@RestController
@RequestMapping("/api/homestay")
public class HomestayController {

        @Autowired
        private IHomestayService homestayService;

        @Autowired
        private ModelMapper modelMapper;

        @PostMapping("/new-homestay")
        @PreAuthorize("hasAuthority('homestay:create')")
        public ResponseEntity<?> createHomestay(@RequestBody HomestayRequestDto homestay) {
                Homestay saveHomestay = modelMapper.map(homestay, Homestay.class);
                Homestay savedHomestay = homestayService.createHomestay(saveHomestay);
                HomestayResponseDto responseHomestay = modelMapper.map(savedHomestay, HomestayResponseDto.class);
                responseHomestay.setAddress(responseHomestay.getAddress().split("_")[0]);

                return new ResponseEntity<HomestayResponseDto>(responseHomestay, HttpStatus.CREATED);
        }

        @PostMapping("/new-bloc")
        @PreAuthorize("hasAuthority('homestay:create')")
        public ResponseEntity<?> createBloc(@RequestBody BlocHomestayRequestDto bloc) {
                BlocHomestay saveBloc = modelMapper.map(bloc, BlocHomestay.class);
                BlocHomestay savedBloc = homestayService.createBlocHomestay(saveBloc);
                BlocHomestayResponseDto responseBloc = modelMapper.map(savedBloc, BlocHomestayResponseDto.class);
                responseBloc.setAddress(responseBloc.getAddress().split("_")[0]);
                return new ResponseEntity<BlocHomestayResponseDto>(responseBloc, HttpStatus.CREATED);
        }

        @GetMapping("/homestay-list")
        @PreAuthorize("hasAuthority('homestay:view')")
        public ResponseEntity<?> findHomestayList(@RequestParam String filter, @RequestParam String param,
                        @RequestParam int page, @RequestParam int size, @RequestParam Boolean isNextPage,
                        @RequestParam Boolean isPreviousPage) {
                Page<Homestay> homestays = homestayService.findHomestayList(filter, param.toUpperCase(), page, size,
                                isNextPage,
                                isPreviousPage);
                List<HomestayResponseDto> homestayDtos = homestays.stream()
                                .map(h -> modelMapper.map(h, HomestayResponseDto.class))
                                .collect(Collectors.toList());
                homestayDtos.forEach(h -> h.setAddress(h.getAddress().split("_")[0]));

                HomestayListPagingDto homestayResponseListDto = new HomestayListPagingDto(homestayDtos,
                                new ArrayList<>(),
                                homestays.getPageable().getPageNumber());

                return new ResponseEntity<HomestayListPagingDto>(homestayResponseListDto, HttpStatus.OK);
        }

        @GetMapping("/user/bloc-list")
        public ResponseEntity<?> findBlocList(@RequestParam String status, @RequestParam int page,
                        @RequestParam int size,
                        @RequestParam boolean isNextPage, boolean isPreviousPage) {
                Page<BlocHomestay> blocs = homestayService.findBlocHomestaysByStatus(status, page, size, isNextPage,
                                isPreviousPage);
                List<BlocHomestayResponseDto> blocHomestayDtos = blocs.stream()
                                .map(b -> modelMapper.map(b, BlocHomestayResponseDto.class))
                                .collect(Collectors.toList());
                blocHomestayDtos.forEach(b -> b.setAddress(b.getAddress().split("_")[0]));
                BlocHomestayListPagingDto blocHomestayListPagingDto = new BlocHomestayListPagingDto(blocHomestayDtos,
                                blocs.getNumber());
                return new ResponseEntity<BlocHomestayListPagingDto>(blocHomestayListPagingDto, HttpStatus.OK);
        }

        @GetMapping("/user/detail")
        public ResponseEntity<?> findHomestayByName(@RequestParam String name) {
                Homestay homestay = homestayService.findHomestayByName(name);
                HomestayResponseDto responseHomestay = modelMapper.map(homestay, HomestayResponseDto.class);
                responseHomestay.setAddress(responseHomestay.getAddress().split("_")[0]);

                return new ResponseEntity<HomestayResponseDto>(responseHomestay, HttpStatus.OK);
        }

        @GetMapping("/user/city-provinces")
        public ResponseEntity<?> getHomestayCityOrProvinceList() {
                List<String> homestayCityOrProvinceList = homestayService.getHomestayCityOrProvince();
                List<String> blocCityOrProvinceList = homestayService.getBlocCityOrProvince();
                List<TotalHomestayFromCityProvinceResponseDto> totalHomestays = homestayCityOrProvinceList.stream()
                                .map(h -> {
                                        Integer total = homestayService.getTotalHomestayOnLocation(h);
                                        TotalHomestayFromCityProvinceResponseDto totalHomestayFromCityProvinceResponseDto = new TotalHomestayFromCityProvinceResponseDto(
                                                        h, total);
                                        return totalHomestayFromCityProvinceResponseDto;
                                }).sorted().collect(Collectors.toList());
                List<TotalBlocFromCityProvinceResponseDto> totalBlocs = blocCityOrProvinceList.stream().map(b -> {
                        Integer total = homestayService.getTotalBlocOnLocation(b);
                        TotalBlocFromCityProvinceResponseDto totalBlocFromCityProvinceResponseDto = new TotalBlocFromCityProvinceResponseDto(
                                        b, total);
                        return totalBlocFromCityProvinceResponseDto;
                }).sorted().collect(Collectors.toList());
                TotalHomestayFromLocationResponseDto totalHomestay = new TotalHomestayFromLocationResponseDto(
                                totalHomestays, totalBlocs);
                return new ResponseEntity<TotalHomestayFromLocationResponseDto>(totalHomestay, HttpStatus.OK);
        }

        @GetMapping("/user/homestay-rating")
        public ResponseEntity<?> getHomestayListOrderByTotalAverageRating(@RequestParam int page,
                        @RequestParam int size, @RequestParam boolean isNextPage,
                        @RequestParam boolean isPreviousPage) {
                Page<Homestay> homestays = homestayService.getHomestayListOrderByTotalAverageRatingPoint(page, size,
                                isNextPage, isPreviousPage);
                List<HomestayResponseDto> responseHomestayList = homestays.getContent().stream()
                                .map(h -> modelMapper.map(h, HomestayResponseDto.class)).collect(Collectors.toList());
                responseHomestayList.forEach(h -> h.setAddress(h.getAddress().split("_")[0]));

                HomestayListPagingDto responseHomestays = new HomestayListPagingDto(responseHomestayList,
                                new ArrayList<>(),
                                homestays.getNumber());

                return new ResponseEntity<HomestayListPagingDto>(responseHomestays, HttpStatus.OK);
        }

        @GetMapping("/user/bloc-rating")
        public ResponseEntity<?> getBlocListOrderByTotalAverageRating(@RequestParam int page,
                        @RequestParam int size, @RequestParam boolean isNextPage,
                        @RequestParam boolean isPreviousPage) {
                Page<BlocHomestay> blocs = homestayService.getBlocListOrderByTotalAverageRatingPoint(page, size,
                                isNextPage, isPreviousPage);
                List<BlocHomestayResponseDto> responseBlocList = blocs.getContent().stream()
                                .map(b -> modelMapper.map(b, BlocHomestayResponseDto.class))
                                .collect(Collectors.toList());
                responseBlocList.forEach(b -> b.setAddress(b.getAddress().split("_")[0]));
                BlocHomestayListPagingDto blocHomestayListPagingDto = new BlocHomestayListPagingDto(responseBlocList,
                                blocs.getNumber());
                return new ResponseEntity<BlocHomestayListPagingDto>(blocHomestayListPagingDto, HttpStatus.OK);
        }

        @PostMapping("/user/homestay-filter")
        public ResponseEntity<?> filterHomestay(@RequestBody HomestaySearchFilter filter,
                        @RequestParam int page,
                        @RequestParam int size, @RequestParam boolean isNextPage,
                        @RequestParam boolean isPreviousPage) {
                HomestayListPagingDto homestayListPagingDto = new HomestayListPagingDto();
                switch (filter.getHomestayType().toUpperCase()) {
                        case "HOMESTAY":

                                PagedListHolder<Homestay> homestays = homestayService.getHomestayListFiltered(
                                                filter.getFilterOption(), filter.getSearchString(), page, size,
                                                isNextPage,
                                                isPreviousPage);
                                List<HomestayResponseDto> homestayResponseList = homestays.getPageList()
                                                .stream()
                                                .map(h -> modelMapper.map(h, HomestayResponseDto.class))
                                                .collect(Collectors.toList());
                                homestayResponseList.forEach(h -> h.setAddress(h.getAddress().split("_")[0]));

                                homestayListPagingDto.setHomestays(homestayResponseList);
                                homestayListPagingDto.setBlocs(new ArrayList<>());
                                homestayListPagingDto.setPageNumber(homestays.getPage());
                                break;
                        case "BLOC":
                                PagedListHolder<BlocHomestay> blocs = homestayService.getBlocListFiltered(
                                                filter.getFilterOption(), filter.getSearchString(), page, size,
                                                isNextPage,
                                                isPreviousPage);
                                List<BlocHomestayResponseDto> blocResponseList = blocs.getPageList().stream()
                                                .map(b -> modelMapper.map(b, BlocHomestayResponseDto.class))
                                                .collect(Collectors.toList());
                                blocResponseList.forEach(b -> b.setAddress(b.getAddress().split("_")[0]));
                                homestayListPagingDto.setBlocs(blocResponseList);
                                homestayListPagingDto.setHomestays(new ArrayList<>());
                                homestayListPagingDto.setPageNumber(blocs.getPage());
                                break;
                }

                return new ResponseEntity<HomestayListPagingDto>(homestayListPagingDto, HttpStatus.OK);
        }

        @GetMapping("/user/additional-filter")
        public ResponseEntity<?> getAdditionalHomestayFilterInformation(@RequestParam String homestayType) {
                List<String> homestayFactilityNames = homestayService.getAllHomestayFacilityNames(homestayType);
                List<String> homestayServiceNames = homestayService.getAllHomestayServiceNames(homestayType);
                Long homestayHighestPrice = homestayService.getHighestPriceOfHomestay(homestayType);
                Long homestayServiceHighestPrice = homestayService.getHighestPriceOfHomestayService(homestayType);
                FilterAdditionalResponseDto filterAdditionalResponseDto = new FilterAdditionalResponseDto(
                                homestayFactilityNames, homestayServiceNames, homestayHighestPrice,
                                homestayServiceHighestPrice);

                return new ResponseEntity<FilterAdditionalResponseDto>(filterAdditionalResponseDto, HttpStatus.OK);
        }

}
