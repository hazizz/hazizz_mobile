package com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs;

import android.os.Parcel;
import android.os.Parcelable;


import lombok.Data;

@Data
public class POJOgetTask implements Parcelable {

    private int id;
    private String type;
    private String title;
    private String description;
    private POJOsubjectData subjectData;
    private String dueDate;
    private POJOcreator creator;
    private POJOgroupData groupData;

    public POJOgetTask(int id, String type, String title, String description, POJOsubjectData subjectData,
    String dueDate, POJOcreator creator, POJOgroupData groupData){
        this.id = id;
        this.type = type;
        this.title = title;
        this.description = description;
        this.subjectData = subjectData;
        this.dueDate = dueDate;
        this.creator = creator;
        this.groupData = groupData;
    }

    protected POJOgetTask(Parcel in) {
        id = in.readInt();
        type = in.readString();
        title = in.readString();
        description = in.readString();
        dueDate = in.readString();
    }

    public static final Creator<POJOgetTask> CREATOR = new Creator<POJOgetTask>() {
        @Override
        public POJOgetTask createFromParcel(Parcel in) {
            return new POJOgetTask(in);
        }

        @Override
        public POJOgetTask[] newArray(int size) {
            return new POJOgetTask[size];
        }
    };

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeInt(id);
        parcel.writeString(type);
        parcel.writeString(title);
        parcel.writeString(description);
        parcel.writeString(dueDate);
    }
}
