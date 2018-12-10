package com.indeed.hazizz.Listviews.SubjectList;

import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOcreator;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgroupData;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOsubjectData;

import lombok.Data;

@Data
public class SubjectItem {

    String subjectName;
   /* POJOgroupData groupData;
    POJOsubjectData subjectData;*/
    int subjectId;

    public SubjectItem(String subjectName,/* String taskDescription, POJOgroupData groupData, POJOcreator creator, POJOsubjectData subjectData,*/ int subjectId){
        this.subjectName = subjectName;
       /* this.announcementDescription = taskDescription;
        this.groupData = groupData;
        this.creator = creator;
        this.subjectData = subjectData; */
        this.subjectId = subjectId;
    }
}
