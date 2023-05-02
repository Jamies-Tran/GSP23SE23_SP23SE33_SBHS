package com.sbhs.swm.dto.paging;

import java.util.List;

import com.sbhs.swm.dto.BookingDepositDto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class BookingDepositListPagingDto {
    private List<BookingDepositDto> bookingDeposits;
    private int pageNumber;
    private int totalPage;
}
