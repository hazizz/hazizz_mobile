package com.indeed.hazizz;

import android.util.Log;

import com.indeed.hazizz.Communication.POJO.Response.POJOMembersProfilePic;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public abstract class ProfilePicManager {

    private static HashMap<Integer, POJOMembersProfilePic> pics;
    private static int currentGroupId;

    public static void setCurrentGroupMembersProfilePic(HashMap<Integer, POJOMembersProfilePic> pics1, int groupId){
        pics = pics1;
        currentGroupId = groupId;
        for(Map.Entry<Integer, POJOMembersProfilePic> entry : pics.entrySet()) {
            Log.e("hey",  entry.getKey() + ": " + entry.getValue().getData());
        }
    }

    public static HashMap<Integer, POJOMembersProfilePic> getCurrentGroupMembersProfilePic(){
        return pics;
    }

    public static int getCurrentGroupId(){
        return currentGroupId;
    }

}
