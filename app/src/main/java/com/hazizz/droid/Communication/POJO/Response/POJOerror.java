package com.hazizz.droid.Communication.POJO.Response;

import android.util.Log;

import lombok.Data;

@Data
public class POJOerror{

    private String time;
    private int errorCode;
    private String title;
    private String message;

    public POJOerror(String time, int errorCode, String title, String message){
        Log.e("hey", "the time: " + time + "|");
        if(time == null || time.length() == 0){this.time = "null";}else{this.time = time;}
        this.errorCode = errorCode;
        if(title == null || title.length() == 0){this.title = "null";}else{this.title = title;}
        if(message == null || message.length() == 0){this.message = "null";}else{this.message = message;}

    }
}
