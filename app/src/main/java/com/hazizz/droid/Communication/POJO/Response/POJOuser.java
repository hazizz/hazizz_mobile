package com.hazizz.droid.Communication.POJO.Response;

import lombok.Data;

@Data
public class POJOuser implements Pojo{
    private long id;
    private String username;
    private String displayName;
    private String registrationDate;

    POJOuser(long id, String username, String registrationDate){
        this.id = id;
        this.username = username;
        this.registrationDate = registrationDate;
    }

}
