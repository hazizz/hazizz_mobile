package com.indeed.hazizz.Communication.POJO.Response;

import java.util.List;

import lombok.Data;

@Data
public class POJOme {

    private final int id;
    public final String username;
    public final String emailAddress;
    private final List<String> permissions;
    private final List<POJOgroup> groups;
    private final Boolean locked;
    private final Boolean disabled;
    private final Boolean expired;
    private final String registrationDate;
    private final String lastPasswordReset;

    public POJOme(int id, String username, String emailAddress, List<String> permissions, List<POJOgroup> groups, Boolean locked, Boolean disabled, Boolean expired, String registrationDate, String lastPasswordReset) {
        this.id = id;
        this.username = username;
        this.emailAddress = emailAddress;
        this.permissions = permissions;
        this.groups = groups;
        this.locked = locked;
        this.disabled = disabled;
        this.expired = expired;
        this.registrationDate = registrationDate;
        this.lastPasswordReset = lastPasswordReset;
    }
}
