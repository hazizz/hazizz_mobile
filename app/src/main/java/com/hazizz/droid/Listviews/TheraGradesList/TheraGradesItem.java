package com.hazizz.droid.Listviews.TheraGradesList;

import android.os.Parcel;
import android.os.Parcelable;

import lombok.Data;

@Data
public class TheraGradesItem implements Parcelable {

    String Date;
    String Weight;
    String Theme;
    int NumberValue;

    public TheraGradesItem( String Date,  String Weight,  String Theme,  int NumberValue){
        this.Date = Date;
        this.Weight = Weight;
        this.Theme = Theme;
        this.NumberValue = NumberValue;
    }

    protected TheraGradesItem(Parcel in) {
        Date = in.readString();
        Weight = in.readString();
        Theme = in.readString();
        NumberValue = in.readInt();
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(Date);
        dest.writeString(Weight);
        dest.writeString(Theme);
        dest.writeInt(NumberValue);
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

