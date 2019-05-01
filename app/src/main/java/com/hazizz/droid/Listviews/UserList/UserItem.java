package com.hazizz.droid.listviews.UserList;

import lombok.Data;

@Data
public class UserItem {

    long id;
    String displayName;
    String userName;
    String userProfilePic;
    int userRank;

    public UserItem(long id, String displayName, String userName, String userProfilePic, int userRank){
        this.id = id;
        this.displayName = displayName;
        this.userName = userName;
        this.userProfilePic = userProfilePic;
        this.userRank = userRank;
    }
}

