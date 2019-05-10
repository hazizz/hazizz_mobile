package com.hazizz.droid.cache;

import android.util.Log;

import com.hazizz.droid.communication.Strings;

import lombok.Getter;

@Getter
public class Member {

    private long userId;
    private String username;
    private String displayName;
    Strings.Rank rank;
    private String profilePic;

    short setup_phase = 0;

    Member(long userId, String username, String displayName, Strings.Rank rank){
        this.userId = userId;
        setData(username, displayName, rank);
    }

    Member(long userId, String profilePic){
        this.userId = userId;

        setProfilePic(profilePic);
    }


    public void setData(String username, String displayName, Strings.Rank rank){
        this.username = username;
        this.displayName = displayName;
        this.rank = rank;

        setup_phase++;
    }
    public void setProfilePic(String profilePic){

        Log.e("hey", "qwerp1: " + profilePic);
        this.profilePic = profilePic;
        Log.e("hey", "qwerp2: " + this.profilePic);
        setup_phase++;
    }

    public boolean isReady(){
        return setup_phase >= 2;
    }
}
