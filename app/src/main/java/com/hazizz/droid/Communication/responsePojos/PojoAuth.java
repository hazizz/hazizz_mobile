package com.hazizz.droid.communication.responsePojos;

import lombok.Data;

@Data
public class PojoAuth implements Pojo{

    public PojoAuth(String token, String refresh){
        this.token = token;
        this.refresh = refresh;
    }
    private String token;
    private String refresh;

}
