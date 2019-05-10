package com.hazizz.droid.communication.responsePojos.taskPojos;

import com.hazizz.droid.communication.responsePojos.PojoAssignation;
import com.hazizz.droid.communication.responsePojos.PojoGroup;
import com.hazizz.droid.communication.responsePojos.PojoSubject;
import com.hazizz.droid.communication.responsePojos.PojoType;

import lombok.Data;

@Data
public class PojoTaskDetailed  extends PojoTask {

    private String creationDate;
    private String lastUpdated;

    public PojoTaskDetailed(int id, PojoAssignation assignation, PojoType type, String title, String description, String dueDate, PojoCreator creator,
                               String creationDate, String lastUpdated, PojoGroup group,  PojoSubject subject){
        super(id, type, title, description, dueDate, creator, group, subject);
        this.creationDate = creationDate;
        this.lastUpdated = lastUpdated;

    }
}
