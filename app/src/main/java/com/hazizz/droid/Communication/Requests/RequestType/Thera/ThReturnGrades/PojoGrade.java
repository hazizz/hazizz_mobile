package com.hazizz.droid.communication.requests.RequestType.Thera.ThReturnGrades;

import lombok.Data;

@Data
public class PojoGrade {

    private String date;
    private String creationDate;
    private String subject;
    private String topic;
    private String gradeType;
    private String grade;
    private String weight;

    public PojoGrade(String date, String creationDate, String subject, String topic, String gradeType, String grade, String weight) {
        this.date = date;
        this.creationDate = creationDate;
        this.subject = subject;
        this.topic = topic;
        this.gradeType = gradeType;
        this.grade = grade;
        this.weight = weight;
    }
}
