package com.hazizz.droid.cache.MeInfo;

import com.hazizz.droid.communication.Strings;

import lombok.Data;

@Data
public class MeInfo {

    private long userId = 0;
    private String profileName = "";
    private String displayName = "";
    private String profileEmail = "";
    private String profilePic = "";
    private String password = "";
    private Strings.Rank rankInCurrentGroup = Strings.Rank.NULL;



    private static MeInfo instance = null;
    private MeInfo(){ }

    public static MeInfo getInstance() {
        if(instance == null){
            instance = new MeInfo();
        }
        return instance;
    }



    /*
    public static long getId(){
        return userId;
    }

    public static void setId(long id){
        userId = id;
    }

    public static void setRankInCurrentGroup(Strings.Rank rank){
        rankInCurrentGroup = rank;
    }
    public static Strings.Rank getRankInCurrentGroup(){
        return rankInCurrentGroup;
    }

    public static void setPassword(String p){
        password = p;
    }
    public static String getPassword(){
        return password;
    }

    public static void setProfileName(String pName){
        if(pName != null){
            profileName = pName;
        }else{
            profileName = "username";
        }
    }

    public static String getProfileName(){
        return profileName;
    }

    public static void setDisplayName(String dName){
        displayName = dName;
    }
    public static String getDisplayName(){
        return displayName;
    }

    public static void setProfileEmail(String pEmail){
        profileEmail = pEmail;
    }
    public static String getProfileEmail(){
        return profileEmail;
    }

    public static void setProfilePic(String base64_pic){
        profilePic = base64_pic;
    }
    public static String getProfilePic(){
        return profilePic;
    }
}
    */

}
