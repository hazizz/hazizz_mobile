package com.hazizz.droid.listviews.TaskList;

import com.hazizz.droid.Communication.responsePojos.PojoGroup;
import com.hazizz.droid.Communication.responsePojos.PojoSubject;
import com.hazizz.droid.Communication.responsePojos.taskPojos.PojoCreator;

import lombok.Data;

@Data
public class TaskItem {

    int taskPic;
    String taskTitle;
    String taskDescription;
  //  String taskDueDate;
    PojoGroup group;
    PojoCreator creator;
     PojoSubject subject;
    int taskId;

    public TaskItem(int taskPic, String taskTitle, String taskDescription,PojoGroup group, PojoCreator creator,  PojoSubject subject, int taskId){
        this.taskPic = taskPic;
        this.taskTitle = taskTitle;
        this.taskDescription = taskDescription;

        this.group = group;
        this.creator = creator;
        this.subject = subject;
        this.taskId = taskId;
    }
}

