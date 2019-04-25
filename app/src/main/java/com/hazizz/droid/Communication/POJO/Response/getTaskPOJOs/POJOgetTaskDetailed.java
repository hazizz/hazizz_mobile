package com.hazizz.droid.Communication.POJO.Response.getTaskPOJOs;

import com.hazizz.droid.Communication.POJO.Response.POJOgroup;
import com.hazizz.droid.Communication.POJO.Response.POJOsubject;
import com.hazizz.droid.Communication.POJO.Response.Pojo;
import com.hazizz.droid.Communication.POJO.Response.PojoAssignation;
import com.hazizz.droid.Communication.POJO.Response.PojoType;

import lombok.Data;

@Data
public class POJOgetTaskDetailed  implements Pojo {
    private int id;
    private PojoAssignation assignation;
    private PojoType type;
    private String title;
    private String description;
    private String creationDate;
    private String lastUpdated;
    private String dueDate;
    private POJOcreator creator;
    private POJOgroup group;
    private POJOsubject subject;

    public POJOgetTaskDetailed(int id, PojoAssignation assignation, PojoType type, String title, String description, String dueDate, POJOcreator creator,
                               String creationDate, String lastUpdated, POJOgroup group, POJOsubject subject){
        this.id = id;
        this.assignation = assignation;
        this.type = type;
        this.title = title;
        this.description = description;
        this.creationDate = creationDate;
        this.lastUpdated = lastUpdated;
        this.subject = subject;
        this.dueDate = dueDate;
        this.creator = creator;
        this.group = group;
    }
}
