package com.sbhs.swm.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class HomestaySearchFilter {
    private FilterOption filterOption;
    private String searchString;
    private Integer page;
    private Integer size;
}
