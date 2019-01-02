package com.indeed.hazizz.Communication.POJO.Response.AnnouncementPOJOs;


import com.indeed.hazizz.Communication.POJO.Response.POJOgroup;
import com.indeed.hazizz.Communication.POJO.Response.POJOsubject;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOcreator;

import lombok.Data;

@Data
public class POJOAnnouncement {

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
