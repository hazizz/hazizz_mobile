package com.hazizz.droid.Listviews.TheraReturnSchedules;

import lombok.Data;

@Data
public class ClassItem {

    String startOfClass;

    public ClassItem(String startOfClass, String endOfClass, boolean cancelled, boolean standIn, String subjectCategoryName, String date, String count, String classGroup, String teacher, String classRoom) {
        this.startOfClass = startOfClass;
        this.endOfClass = endOfClass;
        this.cancelled = cancelled;
        this.standIn = standIn;
        SubjectCategoryName = subjectCategoryName;
        Date = date;
        Count = count;
        ClassGroup = classGroup;
        Teacher = teacher;
        ClassRoom = classRoom;
    }

    String endOfClass;
    boolean cancelled;
    boolean standIn;
    String SubjectCategoryName;
    String Date;
    String Count;
    String ClassGroup;
    String Teacher;
    String ClassRoom;

}
