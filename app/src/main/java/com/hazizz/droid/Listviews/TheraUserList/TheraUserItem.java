package com.hazizz.droid.listviews.TheraUserList;

import lombok.Data;

@Data
public class TheraUserItem {

    long id;
    String status;
    String username;
    String url;

    public TheraUserItem(long id, String status, String username, String url){
        this.id = id;
        this.status = status;
        this.username = username;
        this.url = url;
    }
}

