package com.sbhs.swm.models;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;

import com.sbhs.swm.models.status.DepositStatus;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
public class Deposit extends BaseModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private @Setter String status = DepositStatus.UNPAID.name();

    @OneToMany(mappedBy = "deposit", cascade = { CascadeType.PERSIST, CascadeType.REMOVE })
    private @Setter List<BookingDeposit> bookingDeposits;

    @ManyToOne
    private @Setter PassengerWallet passengerWallet;

}
