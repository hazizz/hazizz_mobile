package com.hazizz.droid.Communication.POJO.Response.getTaskPOJOs;

import android.os.Parcel;
import android.os.Parcelable;

import com.hazizz.droid.Communication.POJO.Response.POJOgroup;
import com.hazizz.droid.Communication.POJO.Response.POJOsubject;
import com.hazizz.droid.Communication.POJO.Response.Pojo;
import com.hazizz.droid.Communication.POJO.Response.PojoAssignation;
import com.hazizz.droid.Communication.POJO.Response.PojoType;

import lombok.Data;

@Data
public class POJOgetTask implements Parcelable, Pojo {

    private int id;
    private PojoAssignation assignation;
    private PojoType type;
    private String title;
    private String description;
    private String creationDate;
    private String dueDate;
    private POJOcreator creator;
    private POJOgroup group;
    private POJOsubject subject;

    public POJOgetTask(int id, PojoType type, String title, String description, String creationDate, String dueDate, POJOcreator creator,
                       POJOgroup group, POJOsubject subject){
        this.id = id;
        this.type = type;
        this.title = title;
        this.creationDate = creationDate;
        this.description = description;
        this.subject = subject;
        this.dueDate = dueDate;
        this.creator = creator;
        this.group = group;
    }

    protected POJOgetTask(Parcel in) {
        id = in.readInt();
        title = in.readString();
        description = in.readString();
        creationDate = in.readString();
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
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(id);
        dest.writeString(title);
        dest.writeString(description);
        dest.writeString(creationDate);
        dest.writeString(dueDate);
    }
}
