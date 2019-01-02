package com.indeed.hazizz.Communication.POJO.Response.AnnouncementPOJOs;

import com.indeed.hazizz.Communication.POJO.Response.POJOcommentSection;
import com.indeed.hazizz.Communication.POJO.Response.POJOgroup;
import com.indeed.hazizz.Communication.POJO.Response.POJOsubject;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOcreator;

import java.util.List;

import lombok.Data;

@Data
public class POJODetailedAnnouncement {
    private int id;
    private String title;
    private String description;
    private String creationDate;
    private String lastUpdated;
    private POJOcreator creator;
    private POJOgroup group;
    private POJOsubject subject;
  //  private List<POJOcommentSection> sections;

    public POJODetailedAnnouncement(int id, String title, String description, String creationDate, String lastUpdated, POJOsubject subject, POJOcreator creator, POJOgroup group ){//, List<POJOcommentSection> sections){
        this.id = id;
        this.title = title;
        this.description = description;
        this.creationDate = creationDate;
        this.lastUpdated = lastUpdated;
        this.creator = creator;
        this.group = group;
        this.subject = subject;
     //   this.sections = sections;
    }

}