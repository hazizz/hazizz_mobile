package com.indeed.hazizz.Listviews.TaskList;

import android.widget.ImageView;
import android.widget.TextView;

import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgroupData;
import com.indeed.hazizz.R;

import lombok.Data;

@Data
public class TaskItem {

    int taskPic;
    String taskTitle;
    String taskDescription;
    String taskDueDate;
    POJOgroupData groupData;
    long taskId;

    public TaskItem(int taskPic, String taskTitle, String taskDescription, String taskDueDate, POJOgroupData groupData, long taskId){
        this.taskPic = taskPic;
        this.taskTitle = taskTitle;
        this.taskDescription = taskDescription;
        this.taskDueDate = taskDueDate;
        this.groupData = groupData;
        this.taskId = taskId;
    }
}

