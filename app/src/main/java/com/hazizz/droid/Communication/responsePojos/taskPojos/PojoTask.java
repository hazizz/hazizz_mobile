package com.hazizz.droid.Communication.responsePojos.taskPojos;

import android.os.Parcel;
import android.os.Parcelable;

import com.hazizz.droid.Communication.responsePojos.Pojo;
import com.hazizz.droid.Communication.responsePojos.PojoAssignation;
import com.hazizz.droid.Communication.responsePojos.PojoGroup;
import com.hazizz.droid.Communication.responsePojos.PojoSubject;
import com.hazizz.droid.Communication.responsePojos.PojoType;

import lombok.Data;

@Data
public class PojoTask implements Parcelable, Pojo {

    private int id;
    private PojoAssignation assignation;
    private PojoType type;
    private String title;
    private String description;
    private String creationDate;
    private String dueDate;
    private PojoCreator creator;
    private PojoGroup group;
    private PojoSubject subject;

    public PojoTask(int id, PojoType type, String title, String description, String creationDate, String dueDate, PojoCreator creator,
                       PojoGroup group,  PojoSubject subject){
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

    protected PojoTask(Parcel in) {
        id = in.readInt();
        title = in.readString();
        description = in.readString();
        creationDate = in.readString();
        dueDate = in.readString();
    }

    public static final Creator<PojoTask> CREATOR = new Creator<PojoTask>() {
        @Override
        public PojoTask createFromParcel(Parcel in) {
            return new PojoTask(in);
        }

        @Override
        public PojoTask[] newArray(int size) {
            return new PojoTask[size];
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
