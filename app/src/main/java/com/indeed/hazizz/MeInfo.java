package com.indeed.hazizz;

import lombok.Data;

@Data
public class MeInfo {


    private static String profileName;
    private static String profileEmail;

    public static void setProfileName(String pName){
        profileName = pName;
    }

    public static String getProfileName(){
        return profileName;
    }
    public static void setProfileEmail(String pEmail){
        profileEmail = pEmail;
    }
    public static String getProfileEmail(){
        return profileEmail;
    }

}
