package com.sbhs.swm.handlers.exceptions;

public class RoleNotFoundException extends NotFoundException {

    public RoleNotFoundException() {
        super("Role not found");
    }

}
