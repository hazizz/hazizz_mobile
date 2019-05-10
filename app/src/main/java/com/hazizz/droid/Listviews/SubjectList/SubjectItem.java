package com.hazizz.droid.listviews.SubjectList;

import lombok.Data;

@Data
public class SubjectItem {

    String subjectName;
    int subjectId;

    public SubjectItem(String subjectName, int subjectId){
        this.subjectName = subjectName;
        this.subjectId = subjectId;
    }
}
