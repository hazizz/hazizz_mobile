package com.hazizz.droid.Listviews.TheraUserList;

import lombok.Data;

@Data
public class TheraUserItem {

    long id;
    String status;
    String url;

    public TheraUserItem(long id, String status, String url){
        this.id = id;
        this.status = status;
        this.url = url;
    }
}

