package com.indeed.hazizz.Listviews.AnnouncementList;

import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOcreator;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgroupData;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOsubjectData;

import lombok.Data;

@Data
public class AnnouncementItem {

    String announcementTitle;
    String announcementDescription;
    POJOgroupData groupData;
    POJOcreator creator;
    POJOsubjectData subjectData;
    int announcementId;

    public AnnouncementItem(String taskTitle, String taskDescription, POJOgroupData groupData, POJOcreator creator, POJOsubjectData subjectData, int announcementId){
        this.announcementTitle = taskTitle;
        this.announcementDescription = taskDescription;
        this.groupData = groupData;
        this.creator = creator;
        this.subjectData = subjectData;
        this.announcementId = announcementId;
    }
}
