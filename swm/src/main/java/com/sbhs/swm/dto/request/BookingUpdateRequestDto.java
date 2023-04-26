package com.sbhs.swm.dto.request;

import java.util.List;

import com.sbhs.swm.dto.BookingHomestayServiceDto;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class BookingUpdateRequestDto {
    private Long id;
    private String bookingFrom;
    private String bookingTo;
    private List<BookingHomestayUpdateRequestDto> bookingHomestays;
    private List<BookingHomestayServiceDto> bookingHomestayServices;
}
