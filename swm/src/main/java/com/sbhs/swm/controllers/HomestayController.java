package com.sbhs.swm.controllers;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
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

import com.sbhs.swm.dto.BlocHomestayDto;
import com.sbhs.swm.dto.HomestayDto;
import com.sbhs.swm.dto.paging.HomestayListPagingDto;
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
    public ResponseEntity<?> createHomestay(@RequestBody HomestayDto homestay) {
        Homestay saveHomestay = modelMapper.map(homestay, Homestay.class);
        Homestay savedHomestay = homestayService.createHomestay(saveHomestay);
        HomestayDto responseHomestay = modelMapper.map(savedHomestay, HomestayDto.class);

        return new ResponseEntity<HomestayDto>(responseHomestay, HttpStatus.CREATED);
    }

    @PostMapping("/new-bloc")
    @PreAuthorize("hasAuthority('homestay:create')")
    public ResponseEntity<?> createBloc(@RequestBody BlocHomestayDto bloc) {
        BlocHomestay saveBloc = modelMapper.map(bloc, BlocHomestay.class);
        BlocHomestay savedBloc = homestayService.createBlocHomestay(saveBloc);
        BlocHomestayDto responseBloc = modelMapper.map(savedBloc, BlocHomestayDto.class);

        return new ResponseEntity<BlocHomestayDto>(responseBloc, HttpStatus.CREATED);
    }

    @GetMapping("/list")
    @PreAuthorize("hasAuthority('homestay:view')")
    public ResponseEntity<?> findHomestayList(@RequestParam String filter, @RequestParam String param,
            @RequestParam int page, @RequestParam int size, @RequestParam Boolean isNextPage,
            @RequestParam Boolean isPreviousPage) {
        Page<Homestay> homestays = homestayService.findHomestayList(filter, param.toUpperCase(), page, size, isNextPage,
                isPreviousPage);
        List<HomestayDto> homestayDtos = homestays.stream().map(h -> modelMapper.map(h, HomestayDto.class))
                .collect(Collectors.toList());
        HomestayListPagingDto homestayResponseListDto = new HomestayListPagingDto(homestayDtos,
                homestays.getPageable().getPageNumber());

        return new ResponseEntity<HomestayListPagingDto>(homestayResponseListDto, HttpStatus.OK);
    }

    @GetMapping
    @PreAuthorize("hasAuthority('homestay:view')")
    public ResponseEntity<?> findHomestayByName(@RequestParam String name) {
        Homestay homestay = homestayService.findHomestayByName(name);
        HomestayDto responseHomestay = modelMapper.map(homestay, HomestayDto.class);

        return new ResponseEntity<HomestayDto>(responseHomestay, HttpStatus.OK);
    }

}
