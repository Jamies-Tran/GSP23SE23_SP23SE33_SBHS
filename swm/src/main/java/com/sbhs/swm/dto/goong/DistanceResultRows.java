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
public class DistanceResultRows {
    private List<DistanceResultList> rows;

    // public DistanceResultRows buildFromAnother(DistanceResultRows
    // newDistanceResultRows) {
    // this.setRows(
    // newDistanceResultRows.getRows().stream().map(r ->
    // r.buildFromAnother(r)).collect(Collectors.toList()));
    // return this;
    // }
}
