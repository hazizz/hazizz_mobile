package com.hazizz.droid.listviews.TaskList;

import com.hazizz.droid.communication.responsePojos.PojoGroup;
import com.hazizz.droid.communication.responsePojos.PojoSubject;
import com.hazizz.droid.communication.responsePojos.taskPojos.PojoCreator;
import com.hazizz.droid.listviews.Item;
import com.hazizz.droid.listviews.ItemTypeEnum;

import lombok.Data;

@Data
public class TaskItem extends Item {

    String taskTitle;
    String taskDescription;
  //  String taskDueDate;
    PojoGroup group;
    PojoCreator creator;
     PojoSubject subject;
    int taskId;

    public TaskItem(String taskTitle, String taskDescription,PojoGroup group, PojoCreator creator,  PojoSubject subject, int taskId){
        super();
        this.taskTitle = taskTitle;
        this.taskDescription = taskDescription;

        this.group = group;
        this.creator = creator;
        this.subject = subject;
        this.taskId = taskId;

        type = ItemTypeEnum.TASK;
    }
}

