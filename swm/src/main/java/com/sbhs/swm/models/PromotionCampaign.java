package com.sbhs.swm.models;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter

public class PromotionCampaign extends BaseModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column
    private @Setter String name;

    @Column
    private @Setter String thumbnailUrl;

    @Column
    private @Setter String description;

    @Column
    private @Setter String status;

    @Column
    private @Setter String startDate;

    @Column
    private @Setter String endDate;

    @Column
    private @Setter int discountPercent;

    @Column
    private @Setter Long totalProfit = 0L;

    @Column
    private @Setter Long totalBooking = 0L;

    @ManyToMany
    @JoinTable(name = "campaign_homestay", joinColumns = @JoinColumn(name = "campaign_id", referencedColumnName = "id"), inverseJoinColumns = @JoinColumn(name = "homestay_id", referencedColumnName = "id"))
    private @Setter List<Homestay> homestays;

    @ManyToMany
    @JoinTable(name = "campaign_bloc", joinColumns = @JoinColumn(name = "campaign_id", referencedColumnName = "id"), inverseJoinColumns = @JoinColumn(name = "bloc_id", referencedColumnName = "id"))
    private @Setter List<BlocHomestay> blocs;

}
