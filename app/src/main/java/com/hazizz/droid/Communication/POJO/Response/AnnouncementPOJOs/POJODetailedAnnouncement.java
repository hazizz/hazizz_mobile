package com.hazizz.droid.Communication.POJO.Response.AnnouncementPOJOs;

import com.hazizz.droid.Communication.POJO.Response.POJOgroup;
import com.hazizz.droid.Communication.POJO.Response.POJOsubject;
import com.hazizz.droid.Communication.POJO.Response.Pojo;
import com.hazizz.droid.Communication.POJO.Response.getTaskPOJOs.POJOcreator;

import lombok.Data;

@Data
public class POJODetailedAnnouncement  implements Pojo {
    private int id;
    private String title;
    private String description;
    private String creationDate;
    private String lastUpdated;
    private POJOcreator creator;
    private POJOgroup group;
    private POJOsubject subject;

    public POJODetailedAnnouncement(int id, String title, String description, String creationDate, String lastUpdated, POJOsubject subject, POJOcreator creator, POJOgroup group ){
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