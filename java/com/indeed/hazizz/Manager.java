package com.indeed.hazizz;

import android.content.Context;
import android.util.Log;

import com.indeed.hazizz.Communication.POJO.Response.POJOMembersProfilePic;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class Manager {


    public static class ThreadManager {
        private static final String threadName = "unique_name";
        private static Thread thisThread = null;
        private static boolean freeze = false;

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
            if(pics == null){
          /*  CustomResponseHandler rh = new CustomResponseHandler() {
                @Override
                public void onResponse(HashMap<String, Object> response) { }
                @Override
                public void onPOJOResponse(Object response) {
                    return (HashMap<Integer, POJOMembersProfilePic>)response;
                }
                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) { }
                @Override
                public void onErrorResponse(POJOerror error) { }
                @Override
                public void onEmptyResponse() { }
                @Override
                public void onSuccessfulResponse() { }
                @Override
                public void onNoConnection() { }
            };
            Request r = new Request(context, "GetGroupMembersProfilePicSync", null, rh, null);
            r.requestType = new Request.GetGroupMembersProfilePicSync(); */
                // return new ;
                return null;
            }else {
                return pics;
            }
        }

        public static int getCurrentGroupId(){
            return currentGroupId;
        }

    }

    public static class DestManager{
        private static int dest;
        public static final int TOCREATETASK = 0;
        public static final int TOCREATEANNOUNCEMENT = 1;

        public static void setDest(int a){
            dest = a;
        }

        public static int getDest(){
            return dest;
        }

    }
}
