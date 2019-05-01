package com.hazizz.droid.listviews.TheraReturnSchedules;

import android.os.Parcel;
import android.os.Parcelable;

import lombok.Data;

@Data
public class ClassItem implements Parcelable {

    private String date;
    private String startOfClass;
    private String endOfClass;
    private int periodNumber;
    private boolean cancelled;
    private boolean standIn;
    private String subject;
    private String className;
    private String teacher;
    private String room;
    private String topic;

    public ClassItem(String date, String startOfClass, String endOfClass, int periodNumber, boolean cancelled, boolean standIn, String subject, String className, String teacher, String room, String topic) {
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

    protected ClassItem(Parcel in) {
        date = in.readString();
        startOfClass = in.readString();
        endOfClass = in.readString();
        periodNumber = in.readInt();
        cancelled = in.readByte() != 0x00;
        standIn = in.readByte() != 0x00;
        subject = in.readString();
        className = in.readString();
        teacher = in.readString();
        room = in.readString();
        topic = in.readString();
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(date);
        dest.writeString(startOfClass);
        dest.writeString(endOfClass);
        dest.writeInt(periodNumber);
        dest.writeByte((byte) (cancelled ? 0x01 : 0x00));
        dest.writeByte((byte) (standIn ? 0x01 : 0x00));
        dest.writeString(subject);
        dest.writeString(className);
        dest.writeString(teacher);
        dest.writeString(room);
        dest.writeString(topic);
    }

    @SuppressWarnings("unused")
    public static final Parcelable.Creator<ClassItem> CREATOR = new Parcelable.Creator<ClassItem>() {
        @Override
        public ClassItem createFromParcel(Parcel in) {
            return new ClassItem(in);
        }

        @Override
        public ClassItem[] newArray(int size) {
            return new ClassItem[size];
        }
    };
}