package com.hazizz.droid.Communication.POJO.Response.AnnouncementPOJOs;

import lombok.Data;

@Data
public class POJOGroup {
    private int id;
    private String name;
    private String groupType;
    private int userCount;

    public POJOGroup(int id, String name, String groupType, int userCount){
        this.id = id;
        this.name = name;
        this.groupType = groupType;
        this.userCount = userCount;
    }
}
