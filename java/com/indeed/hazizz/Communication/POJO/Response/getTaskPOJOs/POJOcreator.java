package com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs;

import lombok.Data;

@Data
public class POJOcreator {

    private long id;
    private String username;
    private String registrationDate;

    public POJOcreator(long id, String username, String registrationDate){
        this.id = id;
        this.username = username;
        this.registrationDate = registrationDate;
    }

}
