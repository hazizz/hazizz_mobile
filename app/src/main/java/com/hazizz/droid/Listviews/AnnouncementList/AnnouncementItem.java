package com.hazizz.droid.listviews.AnnouncementList;

import com.hazizz.droid.communication.responsePojos.PojoGroup;
import com.hazizz.droid.communication.responsePojos.PojoSubject;
import com.hazizz.droid.communication.responsePojos.taskPojos.PojoCreator;

import lombok.Data;

@Data
public class AnnouncementItem {

    String announcementTitle;
    String announcementDescription;
    PojoGroup group;
    PojoCreator creator;
     PojoSubject subject;
    int announcementId;

    public AnnouncementItem(String taskTitle, String taskDescription, PojoGroup group, PojoCreator creator,  PojoSubject subject, int announcementId){
        this.announcementTitle = taskTitle;
        this.announcementDescription = taskDescription;
        this.group = group;
        this.creator = creator;
        this.subject = subject;
        this.announcementId = announcementId;
    }
}
