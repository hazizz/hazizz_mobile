package com.hazizz.droid.Communication.POJO.Response;

import lombok.Data;

@Data
public class POJOregister {

    private final String token;

    public POJOregister(String token) {
            this.token = token;
    }
}