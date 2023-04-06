package com.sbhs.swm.models;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class BlocHomestay extends BaseModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(columnDefinition = "nvarchar(500)")
    private @Setter String name;

    @Column(columnDefinition = "nvarchar(500)")
    private @Setter String address;

    @Column(columnDefinition = "nvarchar(500)")
    private @Setter String cityProvince;

    @Column
    private @Setter String businessLicense;

    @Column
    private @Setter String status;

    @Column
    private @Setter double totalAverageRating = 0.0;

    @OneToMany(mappedBy = "bloc", cascade = { CascadeType.PERSIST, CascadeType.REMOVE })
    private @Setter List<Homestay> homestays;

    @OneToMany(mappedBy = "bloc")
    private @Setter List<HomestayService> homestayServices;

    @OneToMany(mappedBy = "bloc", cascade = { CascadeType.REMOVE })
    private @Setter List<Rating> ratings;

    @OneToMany(mappedBy = "bloc", cascade = { CascadeType.PERSIST, CascadeType.REMOVE })
    private @Setter List<HomestayRule> homestayRules;

    @OneToOne
    private @Setter Booking booking;

    @ManyToOne
    private @Setter Landlord landlord;
}
