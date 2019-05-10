package com.hazizz.droid.communication.responsePojos.announcementPojos;


import com.hazizz.droid.communication.responsePojos.PojoGroup;
import com.hazizz.droid.communication.responsePojos.Pojo;
import com.hazizz.droid.communication.responsePojos.PojoSubject;
import com.hazizz.droid.communication.responsePojos.taskPojos.PojoCreator;

import lombok.Data;

@Data
public class PojoAnnouncement implements Pojo {

    private int id;
    private String title;
    private String description;
    private PojoCreator creator;
    private  PojoSubject subject;
    private PojoGroup group;


    public PojoAnnouncement(int id, String title, String description, PojoSubject subject, PojoCreator creator, PojoGroup group){
        this.id = id;
        this.title = title;
        this.description = description;
        this.subject = subject;
        this.creator = creator;
        this.group = group;
    }

}
