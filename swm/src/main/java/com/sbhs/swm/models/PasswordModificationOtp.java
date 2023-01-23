package com.sbhs.swm.models;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "password_otp")
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class PasswordModificationOtp {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(length = 6, unique = true)
    private @Setter String otpToken;

    @OneToOne(mappedBy = "otpToken", cascade = { CascadeType.REFRESH, CascadeType.MERGE })
    private @Setter SwmUser user;
}
