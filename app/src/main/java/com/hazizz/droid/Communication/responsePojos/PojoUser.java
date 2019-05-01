package com.hazizz.droid.Communication.responsePojos;

import lombok.Data;

@Data
public class PojoUser implements Pojo {
    private long id;
    private String username;
    private String displayName;
    private String registrationDate;

    PojoUser(long id, String username, String registrationDate){
        this.id = id;
        this.username = username;
        this.registrationDate = registrationDate;
    }

}
