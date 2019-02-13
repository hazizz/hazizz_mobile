package com.hazizz.droid.Listviews.TaskList;

import com.hazizz.droid.Communication.POJO.Response.POJOgroup;
import com.hazizz.droid.Communication.POJO.Response.POJOsubject;
import com.hazizz.droid.Communication.POJO.Response.getTaskPOJOs.POJOcreator;

import lombok.Data;

@Data
public class TaskItem {

    int taskPic;
    String taskTitle;
    String taskDescription;
  //  String taskDueDate;
    POJOgroup group;
    POJOcreator creator;
    POJOsubject subject;
    int taskId;

    public TaskItem(int taskPic, String taskTitle, String taskDescription,POJOgroup group, POJOcreator creator, POJOsubject subject, int taskId){
        this.taskPic = taskPic;
        this.taskTitle = taskTitle;
        this.taskDescription = taskDescription;

        this.group = group;
        this.creator = creator;
        this.subject = subject;
        this.taskId = taskId;
    }
}

