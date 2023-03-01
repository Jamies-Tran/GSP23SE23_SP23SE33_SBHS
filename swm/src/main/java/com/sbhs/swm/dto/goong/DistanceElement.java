package com.sbhs.swm.dto.goong;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class DistanceElement {
    private Duration duration;
    private Distance distance;
    private String address;
    private String status;

    // public DistanceElement buildFromAnotherDistanceElement(DistanceElement
    // newDistanceElement) {
    // newDistanceElement.setAddress(this.getAddress());

    // return newDistanceElement;
    // }
}
