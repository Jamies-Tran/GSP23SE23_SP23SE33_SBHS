package com.sbhs.swm.dto.paging;

import java.util.List;
import com.sbhs.swm.dto.response.BlocHomestayResponseDto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class BlocHomestayListPagingDto {
    private List<BlocHomestayResponseDto> blocs;
    private Integer pageNumber;
}
