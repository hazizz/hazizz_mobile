package com.hazizz.droid.communication.responsePojos;

import lombok.Data;

@Data
public class PojoGroup implements Pojo {

    private int id;
    private String name;
    private String uniqueName;
    private String groupType;
    private long userCount;

    public PojoGroup(){
    }

    @Override
    public String toString() {
        return this.name;
    }
}
