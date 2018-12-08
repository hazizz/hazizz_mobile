package com.indeed.hazizz.Communication.POJO.Response.AnnouncementPOJOs;

import com.indeed.hazizz.Communication.POJO.Response.POJOcommentSection;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOcreator;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgroupData;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOsubjectData;

import java.util.List;

import lombok.Data;

@Data
public class POJODetailedAnnouncement {
    private int id;
    private String title;
    private String description;
    private int[] creationDate;
    private POJOcreator creator;
    private POJOgroupData group;
    private POJOsubjectData subjectData;
    private List<POJOcommentSection> sections;

    public POJODetailedAnnouncement(int id, String title, String description, int[] creationDate, POJOsubjectData subjectData, POJOcreator creator, POJOgroupData group, List<POJOcommentSection> sections){
        this.id = id;
        this.title = title;
        this.description = description;
        this.creationDate = creationDate;
        this.creator = creator;
        this.group = group;
        this.subjectData = subjectData;
        this.sections = sections;
    }

}