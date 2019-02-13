package com.hazizz.droid.Listviews;

import lombok.Data;

@Data
public class HeaderItem {
    String title;
    String deadline;

    public HeaderItem(String title, String deadline){
        this.title = title;
        this.deadline = deadline;
    }
}
