package com.indeed.hazizz.Communication.POJO.Response;

import lombok.Data;

@Data
public class PojoType {
    private String name;
    private long id;

    PojoType(String name, long id){
        this.name = name;
        this.id = id;
    }

}
