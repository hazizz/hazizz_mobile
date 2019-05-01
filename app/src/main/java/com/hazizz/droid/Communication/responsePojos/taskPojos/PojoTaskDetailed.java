package com.hazizz.droid.Communication.responsePojos.taskPojos;

import com.hazizz.droid.Communication.responsePojos.Pojo;
import com.hazizz.droid.Communication.responsePojos.PojoAssignation;
import com.hazizz.droid.Communication.responsePojos.PojoGroup;
import com.hazizz.droid.Communication.responsePojos.PojoSubject;
import com.hazizz.droid.Communication.responsePojos.PojoType;

import lombok.Data;

@Data
public class PojoTaskDetailed  implements Pojo {
    private int id;
    private PojoAssignation assignation;
    private PojoType type;
    private String title;
    private String description;
    private String creationDate;
    private String lastUpdated;
    private String dueDate;
    private PojoCreator creator;
    private PojoGroup group;
    private PojoSubject subject;

    public PojoTaskDetailed(int id, PojoAssignation assignation, PojoType type, String title, String description, String dueDate, PojoCreator creator,
                               String creationDate, String lastUpdated, PojoGroup group,  PojoSubject subject){
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
