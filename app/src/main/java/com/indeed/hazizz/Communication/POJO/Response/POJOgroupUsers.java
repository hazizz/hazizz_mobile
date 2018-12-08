package com.indeed.hazizz.Communication.POJO.Response;

import lombok.Data;

@Data
public class POJOgroupUsers {

    private final int id;
    private final String username;
    private final String registrationDate;

    POJOgroupUsers(int id, String username, String registrationDate){
        this.id = id;
        this.username = username;
        this.registrationDate = registrationDate;

    }

}