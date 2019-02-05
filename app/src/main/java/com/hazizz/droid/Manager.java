package com.hazizz.droid;

import android.content.Context;
import android.util.Log;
import android.util.SparseArray;

import com.google.android.gms.stats.internal.G;
import com.hazizz.droid.Communication.POJO.Response.POJOMembersProfilePic;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.RequestSenderRunnable;
import com.hazizz.droid.Communication.Strings;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import lombok.Data;
import okhttp3.ResponseBody;
import retrofit2.Call;

public class Manager {

    public static class ThreadManager {
        private static final String threadName = "unique_name";
        private static Thread thisThread = null;
        private static boolean freeze = false;
        private static boolean delay = false;

        public static void startThreadIfNotRunning(Context context){
            Set<Thread> threads = Thread.getAllStackTraces().keySet();

            boolean foundIt = false;
            for (Thread t : threads) {
                if(t.getName().equals(threadName)){
                    foundIt = true;
                    thisThread = t;
                    break;
                }
            }
            if(!foundIt){
                Thread SenderThread = new Thread(new RequestSenderRunnable(context), threadName);
                SenderThread.start();
            }
        }

        public static Thread getThread(){
            Set<Thread> threads = Thread.getAllStackTraces().keySet();
            for (Thread t : threads) {
                if(t.getName().equals(threadName)){
                    return t;
                }
            }
            return null;
        }

        public static void startDelay(){
            delay = true;
        }
        public static void endDelay(){
            delay = false;
        }
        public static boolean isDelayed(){
            return delay;
        }

        public static void freezeThread(){
            freeze = true;
        }
        public static void unfreezeThread(){
            freeze = false;
        }
        public static boolean isFreezed(){
            return freeze;
        }
    }


    public static class ProfilePicManager {

        private static HashMap<Integer, POJOMembersProfilePic> pics = new HashMap<>();
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

    public static class CrashManager{

        private static POJOerror error = null;
        private static Call<ResponseBody> lastCall = null;

        public static void setCrashData(POJOerror e, Call<ResponseBody> c){
            error = e;
            lastCall = c;
        }

        public static POJOerror getError(){
            return error;
        }

        public static Call<ResponseBody> getLastCall(){
            return lastCall;
        }

        public static void reset(){
            error = null;
            lastCall = null;
        }

    }


    public static class WidgetManager{
        public static final int TOMAIN= 0;
        public static final int TOATCHOOSER = 1;
        private static int dest = TOMAIN;

        public static void setDest(int a){
            dest = a;
        }

        public static int getDest(){
            return dest;
        }

        public static void resetDest(){
            dest = TOMAIN;
        }

    }

    public static class DestManager{
        public static final int TOGROUP= -1;
        public static final int TOMAIN= 0;
        public static final int TOCREATETASK = 1;
        public static final int TOCREATEANNOUNCEMENT = 2;
        public static final int TOSUBJECTS = 3;
        public static final int TOATCHOOSER = 4;
        private static int dest = TOMAIN;

        public static void setDest(int a){
            dest = a;
        }

        public static int getDest(){
            return dest;
        }

        public static void resetDest(){
            dest = TOMAIN;
        }

    }

    @Data
    public static class GroupRankManager{

        private static SparseArray<Strings.Rank> groupRanks = new SparseArray<>();

        public static Strings.Rank getRank(int userId){
            Strings.Rank rank = groupRanks.get(userId);

            for(int i = 0; i < groupRanks.size(); i++) {
                int key = groupRanks.keyAt(i);
                // get the object by the key.
                Log.e("hey", "rank: " + groupRanks.get(key).toString());
            }

            if(rank != null){
                return rank;
            }
            return Strings.Rank.NULL;
        }

        public static void setRank(int userId, Strings.Rank rank){
            groupRanks.put(userId, rank);
            for(int i = 0; i < groupRanks.size(); i++) {
                int key = groupRanks.keyAt(i);
                // get the object by the key.
            }
            Log.e("hey", "rank3: " + groupRanks.get(userId).toString());
        }

        public static void clear(){
            groupRanks.clear();
        }
    }

    @Data
    public static class GroupManager{

        private static String groupName;
        private static int groupId;

        public static void setGroupId(int groupId) {
            GroupManager.groupId = groupId;
        }

        public static void setGroupName(String groupName) {
            GroupManager.groupName = groupName;
        }

        public static int getGroupId() {
            return groupId;
        }

        public static String getGroupName() {
            return groupName;
        }

        public static void leftGroup() {
            setGroupName("");
            setGroupId(0);
            MeInfo.setRankInCurrentGroup(Strings.Rank.NULL);
        }

    }

    public static class MeInfo {

        private static long userId = 0;
        private static String profileName = "";
        private static String displayName = "";
        private static String profileEmail = "";
        private static String profilePic = "";
        private static String password = "";
        private static Strings.Rank rankInCurrentGroup = Strings.Rank.NULL;


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


}
