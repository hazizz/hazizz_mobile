package com.hazizz.droid.Communication.POJO.Response.getTaskPOJOs;

import lombok.Data;

@Data
public class POJOsubjectData {

    private long id;
    private String name;

    public POJOsubjectData(long id, String name){
        this.id = id;
        this.name = name;
    }

}
