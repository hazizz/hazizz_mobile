package com.indeed.hazizz.Communication.POJO.Response;

import lombok.Data;

@Data
public class POJOcreateTask {

    private String taskType;
    private String taskTitle;
    private String description;
    private int subjectId;
    private String dueDate;
}
