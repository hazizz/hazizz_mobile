package com.indeed.hazizz.Listviews.AnnouncementList;

import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOcreator;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgroupData;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOsubjectData;

import lombok.Data;

@Data
public class AnnouncementItem {

    String taskTitle;
    String taskDescription;
    POJOgroupData groupData;
    POJOcreator creator;
    POJOsubjectData subject;
    int taskId;

    public AnnouncementItem(String taskTitle, String taskDescription, POJOgroupData groupData, POJOcreator creator, POJOsubjectData subject, int taskId){
        this.taskTitle = taskTitle;
        this.taskDescription = taskDescription;
        this.groupData = groupData;
        this.creator = creator;
        this.subject = subject;
        this.taskId = taskId;
    }
}
