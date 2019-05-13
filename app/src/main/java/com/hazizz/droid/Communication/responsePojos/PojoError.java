package com.hazizz.droid.communication.responsePojos;

import android.util.Log;

public class PojoError implements Pojo {

    private String time = "null";
    private int errorCode = 0;
    private String title = "null";
    private String message = "null";
    private String url = "null";

    public PojoError(String time, int errorCode, String title, String messag, String url){
        Log.e("hey", "the time: " + time + "|");
        if(time == null || time.length() == 0){this.time = "null";}else{this.time = time;}
        this.errorCode = errorCode;
        if(title == null || title.length() == 0){this.title = "null";}else{this.title = title;}
        if(message == null || message.length() == 0){this.message = "null";}else{this.message = message;}
        this.url = url;
    }
    public String getTime(){
        if(time != null){
            return time;
        }else{
            return "empty";
        }
    }
    public int getErrorCode(){
        return errorCode;
    }
    public String getTitle(){
        if(title != null){
            return title;
        }else{
            return "empty";
        }
    }
    public String getMessage(){
        if(message != null){
            return message;
        }else{
            return "empty";
        }
    }


}
