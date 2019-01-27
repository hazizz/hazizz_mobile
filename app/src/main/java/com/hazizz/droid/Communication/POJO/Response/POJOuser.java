package com.hazizz.droid.Communication.POJO.Response;

import lombok.Data;

@Data
public class POJOuser {
    private int id;
    private String username;
    private String displayName;
    private String registrationDate;

    POJOuser(int id, String username, String registrationDate){
        this.id = id;
        this.username = username;
        this.registrationDate = registrationDate;
    }

}
