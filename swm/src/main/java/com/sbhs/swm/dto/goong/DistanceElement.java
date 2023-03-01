package com.sbhs.swm.dto.goong;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class DistanceElement implements Comparable<DistanceElement> {
    private Duration duration;
    private Distance distance;
    private String address;
    private String status;

    @Override
    public int compareTo(DistanceElement d) {
        if (d.getDistance().getValue() < this.getDistance().getValue()) {
            return -1;
        } else if (d.getDistance().getValue() > this.getDistance().getValue()) {
            return 1;
        } else {
            return 0;
        }
    }

}
