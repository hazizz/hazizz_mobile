package com.hazizz.droid.Communication.Requests.RequestType.Thera.ThReturnSchedules;

import lombok.Data;

@Data
public class PojoClass {

    String date;
    String startOfClass;
    String endOfClass;
    int periodNumber;
    boolean cancelled;
    boolean standIn;
    String subject;
    String className;
    String teacher;
    String room;
    String topic;

    public PojoClass(String date, String startOfClass, String endOfClass, int periodNumber, boolean cancelled, boolean standIn,String subject, String className, String teacher, String room, String topic) {
        this.date = date;
        this.startOfClass = startOfClass;
        this.endOfClass = endOfClass;
        this.periodNumber = periodNumber;
        this.cancelled = cancelled;
        this.standIn = standIn;
        this.subject = subject;
        this.className = className;
        this.teacher = teacher;
        this.room = room;
        this.topic = topic;
    }
}
