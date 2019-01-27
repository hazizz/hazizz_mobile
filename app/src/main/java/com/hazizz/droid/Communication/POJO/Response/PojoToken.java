package com.hazizz.droid.Communication.POJO.Response;

import lombok.Data;

@Data
public class PojoToken {

    String token;

    PojoToken(String token){
        this.token = token;
    }
}
