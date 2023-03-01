package com.sbhs.swm.dto.goong;

import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class DistanceResultList {
    private List<DistanceElement> elements;

    // public DistanceResultList buildFromAnother(DistanceResultList
    // newDistanceElementResultList) {

    // this.setElements(newDistanceElementResultList.getElements().stream()
    // .map(r ->
    // r.buildFromAnotherDistanceElement(r)).collect(Collectors.toList()));
    // return this;

    // }
}
