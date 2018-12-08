package com.indeed.hazizz.Communication.POJO.Response;

public class ResponseInterface {

    private String time;
    private int errorCode;
    private String title;
    private String message;

    public ResponseInterface(String time, int errorCode, String title, String message){
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
