package com.hazizz.droid.communication.responsePojos.announcementPojos;

import com.hazizz.droid.communication.responsePojos.PojoGroup;
import com.hazizz.droid.communication.responsePojos.Pojo;
import com.hazizz.droid.communication.responsePojos.PojoSubject;
import com.hazizz.droid.communication.responsePojos.taskPojos.PojoCreator;

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