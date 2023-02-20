package com.sbhs.swm.models;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class SwmUser extends BaseModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(columnDefinition = "nvarchar(500)", unique = true)
    private @Setter String username;

    @Column
    private @Setter String password;

    @Column(unique = true)
    private @Setter String email;

    @Column(length = 10, unique = true)
    private @Setter String phone;

    @Column(columnDefinition = "nvarchar(500)")
    private @Setter String address;

    @Column(length = 15)
    private @Setter String idCardNumber;

    @Column
    private @Setter String avatarUrl;

    @Column
    private @Setter String dob;

    @Column
    private @Setter String gender;

    @Column
    private @Setter boolean changePassword = false;

    @OneToOne(cascade = { CascadeType.PERSIST, CascadeType.MERGE, CascadeType.REFRESH, CascadeType.REMOVE })
    @JoinColumn(name = "passenger_property_id", referencedColumnName = "id")
    private @Setter Passenger passengerProperty;

    @OneToOne(cascade = { CascadeType.PERSIST, CascadeType.MERGE, CascadeType.REFRESH, CascadeType.REMOVE })
    @JoinColumn(name = "landlord_property_id", referencedColumnName = "id")
    private @Setter Landlord landlordProperty;

    @OneToOne(cascade = { CascadeType.PERSIST, CascadeType.MERGE, CascadeType.REFRESH, CascadeType.REMOVE })
    @JoinColumn(name = "admin_property_id", referencedColumnName = "id")
    private @Setter Admin adminProperty;

    @OneToOne(cascade = { CascadeType.REFRESH, CascadeType.MERGE, CascadeType.REMOVE })
    @JoinColumn(name = "otp_id", referencedColumnName = "id")
    private @Setter PasswordModificationOtp otpToken;

    @ManyToMany(cascade = { CascadeType.MERGE, CascadeType.REFRESH, CascadeType.REMOVE }, fetch = FetchType.EAGER)
    @JoinTable(name = "user_role", joinColumns = @JoinColumn(name = "user_id", referencedColumnName = "Id"), inverseJoinColumns = @JoinColumn(name = "role_id", referencedColumnName = "Id"))
    private @Setter List<SwmRole> roles;

}
