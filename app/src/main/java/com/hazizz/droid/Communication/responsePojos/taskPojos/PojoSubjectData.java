package com.hazizz.droid.Communication.responsePojos.taskPojos;

import lombok.Data;

@Data
public class PojoSubjectData {

    private long id;
    private String name;

    public  PojoSubjectData(long id, String name){
        this.id = id;
        this.name = name;
    }

}
