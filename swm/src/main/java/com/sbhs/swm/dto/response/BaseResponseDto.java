package com.sbhs.swm.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class BaseResponseDto {
    private String createdDate;
    private String createdBy;
    private String updatedDate;
    private String updatedBy;
}
