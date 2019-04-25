package com.hazizz.droid.Communication.POJO.Response;

import lombok.Data;

@Data
public class POJORefreshToken  implements Pojo{
    private String token;
    private String refresh;

    public POJORefreshToken(String token, String refresh){
        this.token = token;
        this.refresh = refresh;
    }

}
