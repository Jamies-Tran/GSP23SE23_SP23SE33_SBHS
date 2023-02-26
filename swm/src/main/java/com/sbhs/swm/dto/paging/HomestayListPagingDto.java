package com.sbhs.swm.dto.paging;

import java.util.List;

import com.sbhs.swm.dto.response.HomestayResponseDto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class HomestayListPagingDto {
    private List<HomestayResponseDto> homestays;
    private Integer pageNumber;
}
