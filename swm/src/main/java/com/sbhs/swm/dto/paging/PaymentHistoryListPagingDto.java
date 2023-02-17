package com.sbhs.swm.dto.paging;

import java.util.List;

import com.sbhs.swm.dto.response.PaymentHistoryResponseDto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class PaymentHistoryListPagingDto {
    private List<PaymentHistoryResponseDto> paymentHistories;
    private Integer pageNumber;
}
