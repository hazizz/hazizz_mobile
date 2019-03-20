package com.hazizz.droid.Listviews.TheraGradesList;

import android.os.Parcel;
import android.os.Parcelable;

import lombok.Data;

@Data
public class TheraGradesItem implements Parcelable{

    private String date;
    private String creationDate;
    private String subject;
    private String topic;
    private String gradeType;
    private String grade;
    private String weight;

    public TheraGradesItem(String date, String creationDate, String subject, String topic, String gradeType, String grade, String weight) {
        this.date = date;
        this.creationDate = creationDate;
        this.subject = subject;
        this.topic = topic;
        this.gradeType = gradeType;
        this.grade = grade;
        this.weight = weight;
    }

    protected TheraGradesItem(Parcel in) {
        date = in.readString();
        creationDate = in.readString();
        subject = in.readString();
        topic = in.readString();
        gradeType = in.readString();
        grade = in.readString();
        weight = in.readString();
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(date);
        dest.writeString(creationDate);
        dest.writeString(subject);
        dest.writeString(topic);
        dest.writeString(gradeType);
        dest.writeString(grade);
        dest.writeString(weight);
    }

    @SuppressWarnings("unused")
    public static final Parcelable.Creator<TheraGradesItem> CREATOR = new Parcelable.Creator<TheraGradesItem>() {
        @Override
        public TheraGradesItem createFromParcel(Parcel in) {
            return new TheraGradesItem(in);
        }

        @Override
        public TheraGradesItem[] newArray(int size) {
            return new TheraGradesItem[size];
        }
    };
}