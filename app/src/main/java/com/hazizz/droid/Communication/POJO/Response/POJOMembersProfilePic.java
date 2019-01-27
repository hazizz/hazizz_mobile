package com.hazizz.droid.Communication.POJO.Response;

import lombok.Data;

@Data
public class POJOMembersProfilePic {

    private String data, type;

    public POJOMembersProfilePic(String data, String type){
        this.data = data;
        this.type = type;
    }

}
