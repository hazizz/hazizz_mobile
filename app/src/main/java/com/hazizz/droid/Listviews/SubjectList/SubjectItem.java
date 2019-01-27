package com.hazizz.droid.Listviews.SubjectList;

import lombok.Data;

@Data
public class SubjectItem {

    String subjectName;
   /* POJOgroup group;
    POJOsubject subject;*/
    int subjectId;

    public SubjectItem(String subjectName,/* String taskDescription, POJOgroup group, POJOcreator creator, POJOsubject subject,*/ int subjectId){
        this.subjectName = subjectName;
       /* this.announcementDescription = taskDescription;
        this.group = group;
        this.creator = creator;
        this.subject = subject; */
        this.subjectId = subjectId;
    }
}
