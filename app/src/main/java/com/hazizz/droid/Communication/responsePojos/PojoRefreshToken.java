package com.hazizz.droid.communication.responsePojos;

import lombok.Data;

@Data
public class PojoRefreshToken  implements Pojo {
    private String token;
    private String refresh;

    public PojoRefreshToken(String token, String refresh){
        this.token = token;
        this.refresh = refresh;
    }

}
