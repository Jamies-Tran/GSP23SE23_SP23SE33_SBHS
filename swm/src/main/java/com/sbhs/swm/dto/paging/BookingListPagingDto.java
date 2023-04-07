package com.sbhs.swm.dto.paging;

import java.util.List;

import com.sbhs.swm.dto.response.BookingResponseDto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class BookingListPagingDto {
    private List<BookingResponseDto> bookings;
    private int pageNumber;
}
