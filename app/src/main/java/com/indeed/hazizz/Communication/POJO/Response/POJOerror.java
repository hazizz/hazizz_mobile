package com.indeed.hazizz.Communication.POJO.Response;

import com.indeed.hazizz.Communication.POJO.Response.*;

import lombok.Data;

@Data
public class POJOerror{// implements ResponseInterface {

    private String time;
    private int errorCode;
    private String title;
    private String message;

    public POJOerror(String time, int errorCode, String title, String message){
        this.time = time;
        this.errorCode = errorCode;
        this.title = title;
        this.message = message;
    }

}
