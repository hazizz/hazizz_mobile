package com.hazizz.droid.Listviews;

import lombok.Data;

@Data
public class HeaderItem {
    String date;

    public HeaderItem(String date){
        this.date = date;
    }
}
