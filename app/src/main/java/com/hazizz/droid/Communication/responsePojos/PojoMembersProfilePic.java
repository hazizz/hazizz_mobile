package com.hazizz.droid.communication.responsePojos;

import lombok.Data;

@Data
public class PojoMembersProfilePic  implements Pojo {

    private String data, type;

    public PojoMembersProfilePic(String data, String type){
        this.data = data;
        this.type = type;
    }

}
