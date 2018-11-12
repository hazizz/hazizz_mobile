package com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs;

import com.indeed.hazizz.Communication.POJO.Response.CommentSectionPOJOs.POJOCommentSection;
import com.indeed.hazizz.Communication.POJO.Response.POJOcommentSection;

import java.util.List;

import lombok.Data;

@Data
public class POJOgetTaskDetailed {


    private long id;
    private String type;
    private String title;
    private String description;
    private int[] creationDate;
    private int[] dueDate;
    private POJOcreator creator;
    private POJOgroupData group;
    private POJOsubjectData subjectData;
    private List<POJOcommentSection> sections;


}
