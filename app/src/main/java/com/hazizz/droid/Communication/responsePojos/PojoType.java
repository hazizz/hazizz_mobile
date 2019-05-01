package com.hazizz.droid.Communication.responsePojos;

import lombok.Data;

@Data
public class PojoType  implements Pojo {
    private String name;
    private long id;

    PojoType(String name, long id){
        this.name = name;
        this.id = id;
    }

}