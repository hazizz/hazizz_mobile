package com.hazizz.droid.communication.responsePojos;

import lombok.Data;

@Data
public class PojoToken implements Pojo {

    String token;

    PojoToken(String token){
        this.token = token;
    }
}
