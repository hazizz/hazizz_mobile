package com.hazizz.droid.Communication.POJO.Response.CommentSectionPOJOs;

import com.hazizz.droid.Communication.POJO.Response.getTaskPOJOs.POJOcreator;

import lombok.Data;

@Data
public class POJOComment {
    private int id;

    private String content;

    private POJOcreator creator;

    private POJOComment[] children;

    private String creationDate;
    private boolean moreChildren;

    public POJOComment(int id, String content, POJOcreator creator, POJOComment[] children, String creationDate, boolean moreChildren) {
        this.id = id;
        this.content =  content;
        this.creator = creator;
        this.children = children;
        this.creationDate = creationDate;
        this.moreChildren = moreChildren;
    }
}
