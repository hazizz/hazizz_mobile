package com.indeed.hazizz.Listviews.TaskList;

import com.indeed.hazizz.Communication.POJO.Response.POJOgroup;
import com.indeed.hazizz.Communication.POJO.Response.POJOsubject;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOcreator;

import lombok.Data;

@Data
public class TaskItem {

    int taskPic;
    String taskTitle;
    String taskDescription;
    String taskDueDate;
    POJOgroup group;
    POJOcreator creator;
    POJOsubject subject;
    int taskId;

    public TaskItem(int taskPic, String taskTitle, String taskDescription, String taskDueDate, POJOgroup group, POJOcreator creator, POJOsubject subject, int taskId){
        this.taskPic = taskPic;
        this.taskTitle = taskTitle;
        this.taskDescription = taskDescription;
        this.taskDueDate = taskDueDate;
        this.group = group;
        this.creator = creator;
        this.subject = subject;
        this.taskId = taskId;
    }
}

