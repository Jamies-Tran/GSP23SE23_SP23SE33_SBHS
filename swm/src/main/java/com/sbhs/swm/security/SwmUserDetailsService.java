package com.sbhs.swm.security;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import com.sbhs.swm.models.SwmUser;
import com.sbhs.swm.security.role_config.Role;
import com.sbhs.swm.services.IUserService;

@Configuration
public class SwmUserDetailsService implements UserDetailsService {

    @Autowired
    private IUserService userService;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        SwmUser user = this.userService.findUserByUsername(username);
        List<SimpleGrantedAuthority> swmUserAuthorities = new ArrayList<>();
        user.getRoles().stream().forEach(r -> {
            swmUserAuthorities.addAll(Role.valueOf(r.getName()).getAuthorities());
        });
        return User.builder().username(user.getUsername()).password(user.getPassword()).authorities(swmUserAuthorities)
                .build();
    }

}
