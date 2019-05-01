package com.hazizz.droid.Communication.responsePojos.announcementPojos;

import com.hazizz.droid.Communication.responsePojos.PojoGroup;
import com.hazizz.droid.Communication.responsePojos.Pojo;
import com.hazizz.droid.Communication.responsePojos.PojoSubject;
import com.hazizz.droid.Communication.responsePojos.taskPojos.PojoCreator;

import lombok.Data;

@Data
public class PojoAnnouncementDetailed  implements Pojo {
    private int id;
    private String title;
    private String description;
    private String creationDate;
    private String lastUpdated;
    private PojoCreator creator;
    private PojoGroup group;
    private  PojoSubject subject;

    public PojoAnnouncementDetailed(int id, String title, String description, String creationDate, String lastUpdated, PojoSubject subject, PojoCreator creator, PojoGroup group ){
        this.id = id;
        this.title = title;
        this.description = description;
        this.creationDate = creationDate;
        this.lastUpdated = lastUpdated;
        this.creator = creator;
        this.group = group;
        this.subject = subject;
    }

}