package com.hazizz.droid.Communication.POJO.Response;

import lombok.Data;

@Data
public class PojoPublicUserData  implements Pojo{

    long id;
    String username;
    String displayName;
    String registrationDate;


    PojoPublicUserData(long id, String username, String displayName, String registrationDate){
        this.id = id;
        this.username = username;
        this.displayName = displayName;
        this.registrationDate = registrationDate;
    }
}
