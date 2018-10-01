package com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs;

import lombok.Data;

@Data
public class POJOgetTask {

    private long id;
    private String type;
    private String title;
    private String description;
    private POJOsubjectData subjectData;
    private String dueDate;
    private POJOgroupData groupData;

    public POJOgetTask(long id, String type, String title, String description, POJOsubjectData subjectData,
    String dueDate, POJOgroupData groupData){
        this.id = id;
        this.type = type;
        this.title = title;
        this.description = description;
        this.subjectData = subjectData;
        this.dueDate = dueDate;
        this.groupData = groupData;
    }
}
