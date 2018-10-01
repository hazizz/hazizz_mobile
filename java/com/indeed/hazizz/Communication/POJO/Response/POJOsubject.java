package com.indeed.hazizz.Communication.POJO.Response;

import lombok.Data;

@Data
public class POJOsubject {

    private long id;

    private String name;


    public POJOsubject(long id, String name) {
        this.id = id;
        this.name = name;
    }

    @Override
    public String toString(){
        return name;
    }
}