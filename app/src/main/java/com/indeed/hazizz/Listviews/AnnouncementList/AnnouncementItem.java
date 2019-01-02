package com.indeed.hazizz.Listviews.AnnouncementList;

import com.indeed.hazizz.Communication.POJO.Response.POJOgroup;
import com.indeed.hazizz.Communication.POJO.Response.POJOsubject;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOcreator;

import lombok.Data;

@Data
public class AnnouncementItem {

    String announcementTitle;
    String announcementDescription;
    POJOgroup group;
    POJOcreator creator;
    POJOsubject subject;
    int announcementId;

    public AnnouncementItem(String taskTitle, String taskDescription, POJOgroup group, POJOcreator creator, POJOsubject subject, int announcementId){
        this.announcementTitle = taskTitle;
        this.announcementDescription = taskDescription;
        this.group = group;
        this.creator = creator;
        this.subject = subject;
        this.announcementId = announcementId;
    }
}
