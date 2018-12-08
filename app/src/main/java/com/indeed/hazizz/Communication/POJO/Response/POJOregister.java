package com.indeed.hazizz.Communication.POJO.Response;

import java.util.List;

import lombok.Data;

@Data
public class POJOregister {

    private final String token;

    public POJOregister(String token) {
            this.token = token;
    }
}