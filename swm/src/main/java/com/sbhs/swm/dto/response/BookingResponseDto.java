package com.sbhs.swm.dto.response;

import java.util.List;

import com.sbhs.swm.dto.BookingDepositDto;
import com.sbhs.swm.dto.HomestayServiceDto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class BookingResponseDto {
    private Long id;
    private String bookingFrom;
    private String bookingTo;
    private Long totalRoom;
    private Long totalPrice;
    private HomestayResponseDto homestay;
    private List<HomestayServiceDto> homestayServices;
    private BookingDepositDto deposit;
    private PassengerResponseDto passenger;
    private String status;
}
