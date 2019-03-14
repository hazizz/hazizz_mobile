package com.hazizz.droid.Listviews.TheraReturnSchedules;

import android.os.Parcel;
import android.os.Parcelable;

import lombok.Data;

@Data
public class ClassItem implements Parcelable {

    String startOfClass;
    String endOfClass;
    boolean cancelled;
    boolean standIn;
    String SubjectCategoryName;
    String Date;
    String Count;
    String ClassGroup;
    String Teacher;
    String ClassRoom;

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

    protected ClassItem(Parcel in) {
        startOfClass = in.readString();
        endOfClass = in.readString();
        cancelled = in.readByte() != 0x00;
        standIn = in.readByte() != 0x00;
        SubjectCategoryName = in.readString();
        Date = in.readString();
        Count = in.readString();
        ClassGroup = in.readString();
        Teacher = in.readString();
        ClassRoom = in.readString();
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(startOfClass);
        dest.writeString(endOfClass);
        dest.writeByte((byte) (cancelled ? 0x01 : 0x00));
        dest.writeByte((byte) (standIn ? 0x01 : 0x00));
        dest.writeString(SubjectCategoryName);
        dest.writeString(Date);
        dest.writeString(Count);
        dest.writeString(ClassGroup);
        dest.writeString(Teacher);
        dest.writeString(ClassRoom);
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