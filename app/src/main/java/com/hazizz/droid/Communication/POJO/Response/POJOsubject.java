package com.hazizz.droid.Communication.POJO.Response;

import lombok.Data;

@Data
public class POJOsubject {

    private int id;

    private String name;


    public POJOsubject(int id, String name) {
        this.id = id;
        this.name = name;
    }

    @Override
    public String toString(){
        return name;
    }
}