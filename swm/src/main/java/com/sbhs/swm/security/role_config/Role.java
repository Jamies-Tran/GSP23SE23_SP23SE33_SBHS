package com.sbhs.swm.security.role_config;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.springframework.security.core.authority.SimpleGrantedAuthority;

import com.google.common.collect.Sets;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@AllArgsConstructor
public enum Role {
    PASSENGER(Sets.newHashSet(Permission.BOOKING_CREATE, Permission.BOOKING_MODIFY, Permission.BOOKING_REMOVE,
            Permission.BOOKING_CANCEL)),
    LANDLORD(Sets.newHashSet(Permission.HOMESTAY_CREATE, Permission.HOMESTAY_MODIFY, Permission.HOMESTAY_REMOVE,
            Permission.BOOKING_CANCEL)),
    ADMIN(Sets.newHashSet(Permission.HOMESTAY_BAN));

    @Getter
    @Setter
    private Set<Permission> permissions;

    public List<SimpleGrantedAuthority> getAuthorities() {
        List<SimpleGrantedAuthority> simpleGrantedAuthorities = new ArrayList<>();
        simpleGrantedAuthorities.add(new SimpleGrantedAuthority("ROLE_".concat(this.name())));
        this.permissions.stream().forEach(p -> {
            simpleGrantedAuthorities.add(new SimpleGrantedAuthority(p.name()));
        });
        return simpleGrantedAuthorities;
    }
}
