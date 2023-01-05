package com.sbhs.swm.models;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
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
import lombok.Setter;

@Entity
@Table
@AllArgsConstructor
@Getter
public class SwmUser {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(columnDefinition = "nvarchar(500)", unique = true)
    private @Setter String username;

    @Column
    private @Setter String password;

    @Column
    private @Setter String email;

    @Column(length = 10, unique = true)
    private @Setter int phone;

    @Column(columnDefinition = "nvarchar(500)")
    private @Setter String address;

    @Column
    private @Setter String gender;

    @OneToOne(cascade = { CascadeType.MERGE, CascadeType.REFRESH, CascadeType.REMOVE })
    private @Setter Passenger passengerProperty;

    @ManyToMany(cascade = { CascadeType.MERGE, CascadeType.REFRESH, CascadeType.REMOVE })
    @JoinTable(name = "user_role", joinColumns = @JoinColumn(name = "user_id", referencedColumnName = "Id"), inverseJoinColumns = @JoinColumn(name = "role_id", referencedColumnName = "Id"))
    private @Setter List<SwmRole> roles;

}
