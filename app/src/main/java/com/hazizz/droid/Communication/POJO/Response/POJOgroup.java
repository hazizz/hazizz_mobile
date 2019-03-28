package com.hazizz.droid.Communication.POJO.Response;

import lombok.Data;

@Data
public class POJOgroup {

    private int id;
    private String name;
    private String uniqueName;
    private String groupType;
    private long userCount;

    public POJOgroup(){
    }

    @Override
    public String toString() {
        return this.name;
    }
}
