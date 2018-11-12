package com.indeed.hazizz.Communication.POJO.Response.CommentSectionPOJOs;

import com.indeed.hazizz.Communication.POJO.Response.POJOgroup;

import java.util.List;

import lombok.Data;

@Data
public class POJOCommentSection {
    private int id;
    private String type;
    private List<POJOComment> comments;
    private POJOParent parent;

    public POJOCommentSection(int id, String type, List<POJOComment> comments, POJOParent parent,
                              POJOGroup group, int[] creationDate){
        this.id = id;
        this.type = type;
        this.comments = comments;
        this.parent = parent;
    }
}
