package com.indeed.hazizz.Listviews.TaskList;

import android.widget.ImageView;
import android.widget.TextView;

import com.indeed.hazizz.R;

public class TaskItem {

    int taskPic;
    String taskTitle;
    String taskDescription;
    String taskDueDate;

    public TaskItem(int pic, String groupName){
        this.taskPic = taskPic;
        this.taskTitle = taskTitle;
        this.taskDescription = taskDescription;
        this.taskDueDate = taskDueDate;
    }
}

