package com.hazizz.droid.Communication.responsePojos.announcementPojos;


import com.hazizz.droid.Communication.responsePojos.PojoGroup;
import com.hazizz.droid.Communication.responsePojos.Pojo;
import com.hazizz.droid.Communication.responsePojos.PojoSubject;
import com.hazizz.droid.Communication.responsePojos.taskPojos.PojoCreator;

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
