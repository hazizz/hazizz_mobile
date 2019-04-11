package com.hazizz.droid.Cache;

import android.app.Activity;
import android.util.Log;
import android.util.SparseArray;

import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOMembersProfilePic;
import com.hazizz.droid.Communication.POJO.Response.POJOuser;
import com.hazizz.droid.Communication.POJO.Response.PojoPermisionUsers;
import com.hazizz.droid.Communication.Requests.GetGroupMemberPermisions;
import com.hazizz.droid.Communication.Requests.GetGroupMembersProfilePic;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Listener.GenericListener;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import lombok.Data;
import lombok.NonNull;

@Data
public class CurrentGroup {

    private static CurrentGroup instance = null;
    private CurrentGroup(){ }

    public static CurrentGroup getInstance() {
        if(instance == null){
            instance = new CurrentGroup();
        }
        return instance;
    }

    private String groupName;
    private long groupId;

                  // id
    private CurrentMembersManager membersManager = new CurrentMembersManager();

    public CurrentMembersManager getMembersManager(){
        return membersManager;
    }

    public List<Member> getMembers(){
        return membersManager.getMembers();
    }


    private GenericListener listener = new GenericListener() {@Override public void execute() { }};
    
    private boolean dataWereSet = false;
    private boolean profilePicsWereSet = false;


    private short requestCount = 0;


    private HashMap<Integer, POJOMembersProfilePic> membersProfilePic = new HashMap<>();

    public void setGroupMembersProfilePic(HashMap<Integer, POJOMembersProfilePic> pics1, int groupId){
        membersProfilePic = pics1;
        for(Map.Entry<Integer, POJOMembersProfilePic> entry : membersProfilePic.entrySet()) {
            Log.e("hey",  entry.getKey() + ": " + entry.getValue().getData());
        }
    }


    private SparseArray<Strings.Rank> ranks = new SparseArray<>();

    private List<POJOuser> owners;
    private List<POJOuser> moderators;
    private List<POJOuser> users;

    public void setRankOwners(List<POJOuser> owners){}
    public void setRankModerators(List<POJOuser> moderators){}
    public void setRankUsers(List<POJOuser> users){}


    public List<POJOuser> getRankOwners(){return owners;}
    public List<POJOuser> getRankModerators(){return moderators;}
    public List<POJOuser> getRankUsers(){return users; }



    public Strings.Rank getRank(int userId){
        Strings.Rank rank = ranks.get(userId);

        for(int i = 0; i < ranks.size(); i++) {
            int key = ranks.keyAt(i);
            // get the object by the key.
            Log.e("hey", "rank: " + ranks.get(key).toString());
        }

        if(rank != null){
            return rank;
        }
        return Strings.Rank.NULL;
    }

    public void setRank(int userId, Strings.Rank rank){
        ranks.put(userId, rank);
        for(int i = 0; i < ranks.size(); i++) {
            int key = ranks.keyAt(i);
            // get the object by the key.
        }
        Log.e("hey", "rank3: " + ranks.get(userId).toString());
    }

    public static void clear(){
     //   ranks.clear();
    }

    public boolean isReady(){
        return membersManager.isReady();
    }


    public boolean groupIdIsSame(long groupId){
        return this.groupId == groupId;
    }

    
    public boolean isReadyData(){
        return dataWereSet;
    }

    public boolean isReadyProfilePics(){
        return profilePicsWereSet;
    }




    public HashMap<Integer, POJOMembersProfilePic> getGroupMembersProfilePic(){
        return membersProfilePic;
    }

    
    
    public void forgetGroup(){
        groupId = 0;
        groupName = null;
        ranks.clear();
        membersProfilePic.clear();

    }

    public void setGroup(Activity activity, long groupId, String groupName, GenericListener listener){
        setOnCollectedAllDataListener(listener);

        this.groupId = groupId;
        this.groupName = groupName;

        requestCount = 0;
        membersManager.clear();
        profilePicsWereSet = false;
        dataWereSet = false;


        CustomResponseHandler r1 = new CustomResponseHandler() {
            @Override public void onPOJOResponse(Object response) {
                PojoPermisionUsers pojoPermisionUser = (PojoPermisionUsers) response;

                membersManager.addMembersByRanks(pojoPermisionUser);

                requestCount++;
                /*
                if (Manager.MeInfo.getId() == creatorId || Manager.MeInfo.getRankInCurrentGroup().getValue() >= Strings.Rank.MODERATOR.getValue()) {
                    button_delete.setVisibility(View.VISIBLE);
                    button_edit.setVisibility(View.VISIBLE);
                }
                */
                ifCollectedAllDataDo();
            }
        };
        MiddleMan.newRequest(new GetGroupMemberPermisions(activity, r1, groupId));

        CustomResponseHandler responseHandler = new CustomResponseHandler() {
            @Override
            public void onPOJOResponse(Object response) {
              //  Manager.ProfilePicManager.setCurrentGroupMembersProfilePic((HashMap<Integer, POJOMembersProfilePic>) response, groupId);

                membersManager.addMembersByProfilePics((HashMap<Long, POJOMembersProfilePic>) response);

                requestCount++;
                ifCollectedAllDataDo();


            }
        };
        MiddleMan.newRequest(new GetGroupMembersProfilePic(activity, responseHandler, groupId));

    }





    public void setGroupId(){

    }


    public void ifCollectedAllDataDo(){
        if(requestCount >= 2){
            onCollectedAllData();
        }
    }

    public void onCollectedAllData(){
        listener.execute();

    }

    @NonNull
    public void setOnCollectedAllDataListener(GenericListener listener){
        this.listener = listener;
    }

}
