package com.indeed.hazizz.Communication.POJO.Response.AnnouncementPOJOs;


import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOcreator;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgroupData;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOsubjectData;

import lombok.Data;

@Data
public class POJOAnnouncement {

    private int id;
    private String title;
    private String description;
    private POJOsubjectData subjectData;
    private POJOcreator creator;
    private POJOgroupData groupData;


    public POJOAnnouncement(int id, String title, String description, POJOsubjectData subjectData, POJOcreator creator, POJOgroupData groupData){
        this.id = id;
        this.title = title;
        this.description = description;
        this.subjectData = subjectData;
        this.creator = creator;
        this.groupData = groupData;
    }

}
