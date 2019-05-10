package com.hazizz.droid.communication.responsePojos.taskPojos;

import com.hazizz.droid.communication.responsePojos.Pojo;

import lombok.Data;

@Data
public class PojoCreator implements Pojo {

    private long id;
    private String username;
    private String displayName;
    private String registrationDate;

    public PojoCreator(long id, String username, String displayName, String registrationDate){
        this.id = id;
        this.username = username;
        this.displayName = displayName;
        this.registrationDate = registrationDate;
    }

}
