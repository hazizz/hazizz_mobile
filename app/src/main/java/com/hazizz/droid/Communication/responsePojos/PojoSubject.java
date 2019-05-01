package com.hazizz.droid.Communication.responsePojos;

import lombok.Data;

@Data
public class  PojoSubject implements Pojo {

    private int id;

    private String name;


    public  PojoSubject(int id, String name) {
        this.id = id;
        this.name = name;
    }

    @Override
    public String toString(){
        return name;
    }
}