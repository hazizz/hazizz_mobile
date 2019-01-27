package com.hazizz.droid.Communication.POJO.Response;

import lombok.Data;

@Data
public class POJOerror{

    private String time;
    private int errorCode;
    private String title;
    private String message;

    public POJOerror(String time, int errorCode, String title, String message){
        if(time == null){time = "null";}else{this.time = time;}
        this.errorCode = errorCode;
        if(title == null){title = "null";}else{this.title = title;}
        if(message == null){message = "null";}else{this.message = message;}

    }
}
