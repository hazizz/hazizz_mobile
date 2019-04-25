package com.hazizz.droid.Communication.POJO.Response;

import lombok.Data;

@Data
public class PojoToken implements Pojo {

    String token;

    PojoToken(String token){
        this.token = token;
    }
}
