package com.indeed.hazizz.Communication.POJO.Response.CommentSectionPOJOs;

import com.indeed.hazizz.Communication.POJO.Response.POJOgroup;
import com.indeed.hazizz.Communication.POJO.Response.POJOuser;

import lombok.Data;

@Data
public class POJOParent {
    private int id;
    private String title;
    private String description;
    private POJOuser user;
    private POJOgroup group;
    private int[] creationDate;


    public POJOParent(int id, String title, String description, POJOuser user, POJOgroup group, int[] creationDate){
        this.id = id;
        this.title = title;
        this.description = description;
        this.user = user;
        this.group = group;
        this.creationDate = creationDate;
    }

}
