package com.indeed.hazizz.Communication.POJO.Response.CommentSectionPOJOs;

import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOcreator;

import org.w3c.dom.Comment;

import lombok.Data;

@Data
public class POJOComment {
    private int id;

    private String content;

    private POJOcreator creator;

    public POJOComment(int id, String content, POJOcreator creator) {
        this.id = id;
        this.content =  content;
        this.creator = creator;
    }
}
