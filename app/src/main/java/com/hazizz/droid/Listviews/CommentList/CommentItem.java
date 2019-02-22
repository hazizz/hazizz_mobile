package com.hazizz.droid.Listviews.CommentList;

import com.hazizz.droid.Communication.POJO.Response.getTaskPOJOs.POJOcreator;

import lombok.Data;

@Data
public class CommentItem {

    long commentId;
    String commentProfilePic;
    POJOcreator creator;
    String commentContent;

    public CommentItem(long commentId, String commentProfilePic, POJOcreator creator, String commentContent){
        this.commentId = commentId;
        this.commentProfilePic = commentProfilePic;
        this.creator = creator;
        this.commentContent = commentContent;
    }
}
