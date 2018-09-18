package com.indeed.hazizz.Communication.POJO.Response;

import com.indeed.hazizz.Communication.POJO.Response.*;

public class Error{// implements ResponseInterface {

    private String time;
    private int errorCode;
    private String title;
    private String message;

    public Error(String time, int drrorCode, String title, String message){
        this.time = time;
        this.errorCode = errorCode;
        this.title = title;
        this.message = message;
    }

    public String getTime(){
        return time;
    }
    public int getErrorCode(){
        return errorCode;
    }
    public String getTitle(){
        return title;
    }
    public String getMessage(){
        return message;
    }

}
