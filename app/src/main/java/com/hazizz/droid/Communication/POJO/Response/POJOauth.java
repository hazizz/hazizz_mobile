package com.hazizz.droid.Communication.POJO.Response;

import lombok.Data;

@Data
public class POJOauth  implements Pojo{

    private String token;
    private String refresh;

    POJOauth(String token){
        this.token = token;
    }
}
