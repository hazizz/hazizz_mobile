package com.hazizz.droid.listviews;

import lombok.Data;

@Data
public class HeaderItem {
    String date;

    public HeaderItem(String date){
        this.date = date;
    }
}
