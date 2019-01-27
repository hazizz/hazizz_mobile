package com.hazizz.droid.Communication.POJO.Response.getTaskPOJOs;

import lombok.Data;

@Data
public class POJOcreator {

    private long id;
    private String username;
    private String displayName;
    private String registrationDate;

    public POJOcreator(long id, String username, String displayName, String registrationDate){
        this.id = id;
        this.username = username;
        this.displayName = displayName;
        this.registrationDate = registrationDate;
    }

}
