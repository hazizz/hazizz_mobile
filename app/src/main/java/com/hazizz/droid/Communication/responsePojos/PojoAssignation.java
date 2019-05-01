package com.hazizz.droid.Communication.responsePojos;

import lombok.Data;

@Data
public class PojoAssignation  implements Pojo {
    private String name;
    private int id;

    PojoAssignation(String name, int id){
        this.name = name;
        this.id = id;
    }
}
