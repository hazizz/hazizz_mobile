package com.indeed.hazizz.Listviews.TaskList;

import android.widget.ImageView;
import android.widget.TextView;

import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOcreator;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgroupData;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOsubjectData;
import com.indeed.hazizz.R;

import java.io.Serializable;

import lombok.Data;

@Data
public class TaskItem {

    int taskPic;
    String taskTitle;
    String taskDescription;
    String taskDueDate;
    POJOgroupData groupData;
    POJOcreator creator;
    POJOsubjectData subject;
    int taskId;

    public TaskItem(int taskPic, String taskTitle, String taskDescription, String taskDueDate, POJOgroupData groupData, POJOcreator creator, POJOsubjectData subject, int taskId){
        this.taskPic = taskPic;
        this.taskTitle = taskTitle;
        this.taskDescription = taskDescription;
        this.taskDueDate = taskDueDate;
        this.groupData = groupData;
        this.creator = creator;
        this.subject = subject;
        this.taskId = taskId;
    }
}

