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

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class Homestay extends BaseModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(columnDefinition = "nvarchar(500)")
    private @Setter String name;

    @Column
    private @Setter Long price;

    @Column(columnDefinition = "nvarchar(500)")
    private @Setter String address;

    @Column
    private @Setter String businessLicense;

    @Column
    private @Setter int availableRooms;

    @Column
    private @Setter String status;

    @OneToMany(mappedBy = "homestay", cascade = { CascadeType.PERSIST, CascadeType.REMOVE })
    private @Setter List<HomestayImage> homestayImages;

    @OneToMany(mappedBy = "homestay", cascade = { CascadeType.PERSIST, CascadeType.REMOVE })
    private @Setter List<HomestayFacility> homestayFacilities;

    @OneToMany(mappedBy = "homestay")
    private @Setter List<Promotion> promotions;

    @OneToMany(mappedBy = "homestay", cascade = { CascadeType.PERSIST, CascadeType.REMOVE })
    private @Setter List<HomestayService> homestayServices;

    @ManyToOne
    private @Setter Landlord landlord;

    @ManyToOne
    private @Setter BlocHomestay bloc;
}
