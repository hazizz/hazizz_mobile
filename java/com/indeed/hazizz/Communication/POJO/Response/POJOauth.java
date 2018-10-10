package com.indeed.hazizz.Communication.POJO.Response;

import lombok.Data;

@Data
public class POJOauth {

    private String token;

    POJOauth(String token){
        this.token = token;
    }
}
