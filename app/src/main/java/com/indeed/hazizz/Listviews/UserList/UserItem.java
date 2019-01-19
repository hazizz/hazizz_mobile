package com.indeed.hazizz.Listviews.UserList;

import lombok.Data;

@Data
public class UserItem {

    String userName;
    String userProfilePic;
    int userRank;

    public UserItem(String userName, String userProfilePic, int userRank){
        this.userName = userName;
        this.userProfilePic = userProfilePic;
        this.userRank = userRank;
    }
}

