package com.sbhs.swm.models;

import javax.persistence.MappedSuperclass;

import lombok.Getter;
import lombok.Setter;

@MappedSuperclass
@Getter
@Setter
public class BaseModel {
    private String createdDate;
    private String createdBy;
    private String updatedDate;
    private String updatedBy;
}
