package com.sbhs.swm.security.role_config;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@AllArgsConstructor
public enum Permission {
    HOMESTAY_VIEW("homestay:view"),
    HOMESTAY_CREATE("homestay:create"),
    HOMESTAY_MODIFY("homestay:modify"),
    HOMESTAY_REMOVE("homestay:remove"),
    HOMESTAY_BAN("homestay:ban"),
    BOOKING_CREATE("booking:create"),
    BOOKING_MODIFY("booking:modify"),
    BOOKING_REMOVE("booking:remove"),
    BOOKING_CANCEL("booking:cancel"),
    PROMOTION_CREATE("promotion:create"),
    PROMOTION_MODIFY("promotion:modify"),
    PROMOTION_REMOVE("promotion:remove"),
    PROMOTION_VIEW("promotion:view"),
    PROMOTION_ADD("promotion:add"),
    PROMOTION_USAGE("promotion:usage"),
    ADMIN_CREATE("admin:create");

    @Getter
    @Setter
    private String permission;
}
