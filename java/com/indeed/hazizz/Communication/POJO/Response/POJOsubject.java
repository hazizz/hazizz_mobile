package com.indeed.hazizz.Communication.POJO.Response;

import lombok.Data;

@Data
public class POJOsubject {

    private String id;
    private String name;

    POJOsubject(String id, String name){
        this.id = id;
        this.name = name;
    }

}
