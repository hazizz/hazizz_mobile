package com.hazizz.droid.listviews.TheraGradesList;

import java.util.List;

import lombok.Data;

@Data
public class TheraSubjectGradesItem {

    private String subjectName;
    private List<TheraGradesItem> grades;

    public TheraSubjectGradesItem(String subjectName, List<TheraGradesItem> grades) {
        this.subjectName = subjectName;
        this.grades = grades;
    }






}
