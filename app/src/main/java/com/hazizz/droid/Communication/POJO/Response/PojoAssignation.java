package com.hazizz.droid.Communication.POJO.Response;

import lombok.Data;

@Data
public class PojoAssignation {
    private String name;
    private int id;

    PojoAssignation(String name, int id){
        this.name = name;
        this.id = id;
    }
}
