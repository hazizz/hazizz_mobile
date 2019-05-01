package com.hazizz.droid.Communication.responsePojos.commentSectionPojos;

import com.hazizz.droid.Communication.responsePojos.Pojo;
import com.hazizz.droid.Communication.responsePojos.taskPojos.PojoCreator;

import lombok.Data;

@Data
public class PojoComment implements Pojo {
    private int id;

    private String content;

    private PojoCreator creator;

    private PojoComment[] children;

    private String creationDate;
    private boolean moreChildren;

    public PojoComment(int id, String content, PojoCreator creator, PojoComment[] children, String creationDate, boolean moreChildren) {
        this.id = id;
        this.content =  content;
        this.creator = creator;
        this.children = children;
        this.creationDate = creationDate;
        this.moreChildren = moreChildren;
    }
}
