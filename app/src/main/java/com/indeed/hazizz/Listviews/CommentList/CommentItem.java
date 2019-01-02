package com.indeed.hazizz.Listviews.CommentList;

import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOcreator;

import lombok.Data;

@Data
public class CommentItem {

    String commentProfilePic;
    String commentName;
    String commentContent;

    public CommentItem(String commentProfilePic, String commentName, String commentContent){
        this.commentProfilePic = commentProfilePic;
        this.commentName = commentName;
        this.commentContent = commentContent;
    }
}
