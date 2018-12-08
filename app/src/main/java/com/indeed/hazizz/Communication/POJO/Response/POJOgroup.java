package com.indeed.hazizz.Communication.POJO.Response;

import java.util.List;

import lombok.Data;

@Data
public class POJOgroup {

    private int id;
    private String name;
    private String groupType;
    private List<POJOgroupUsers> users;
    private List<POJOpost> posts;
    private String creationDate;
    private String lastUpdated;

    public POJOgroup(){
        this.id = id;
        this.name = name;
        this.groupType = groupType;
        this.users = users;
        this.posts = posts;
        this.creationDate = creationDate;
        this.lastUpdated = lastUpdated;
    }
}
