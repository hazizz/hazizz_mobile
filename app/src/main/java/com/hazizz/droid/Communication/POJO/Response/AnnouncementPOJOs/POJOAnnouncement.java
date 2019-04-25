package com.hazizz.droid.Communication.POJO.Response.AnnouncementPOJOs;


import com.hazizz.droid.Communication.POJO.Response.POJOgroup;
import com.hazizz.droid.Communication.POJO.Response.POJOsubject;
import com.hazizz.droid.Communication.POJO.Response.Pojo;
import com.hazizz.droid.Communication.POJO.Response.getTaskPOJOs.POJOcreator;

import lombok.Data;

@Data
public class POJOAnnouncement implements Pojo {

    private int id;
    private String title;
    private String description;
    private POJOcreator creator;
    private POJOsubject subject;
    private POJOgroup group;


    public POJOAnnouncement(int id, String title, String description, POJOsubject subject, POJOcreator creator, POJOgroup group){
        this.id = id;
        this.title = title;
        this.description = description;
        this.subject = subject;
        this.creator = creator;
        this.group = group;
    }

}
