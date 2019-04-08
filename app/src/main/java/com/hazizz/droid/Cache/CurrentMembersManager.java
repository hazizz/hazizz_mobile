package com.hazizz.droid.Cache;

import android.util.Log;

import com.hazizz.droid.Cache.MeInfo.MeInfo;
import com.hazizz.droid.Communication.POJO.Response.POJOMembersProfilePic;
import com.hazizz.droid.Communication.POJO.Response.POJOuser;
import com.hazizz.droid.Communication.POJO.Response.PojoPermisionUsers;
import com.hazizz.droid.Communication.Strings;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CurrentMembersManager {

    // egy member csak userId-val jöhet létre

    List<Member> members = new ArrayList<>();

    PojoPermisionUsers usersData;
    HashMap<Long, POJOMembersProfilePic> profilePics;


    short setupPhase = 0;


    public boolean isReady(){
        return setupPhase >= 2;
    }

    public void addMember(Long userId, String profilePic){
        Member unRegisteredMember = findMember(userId);


        if(unRegisteredMember != null){
            if(!unRegisteredMember.isReady()) {
                unRegisteredMember.setProfilePic(profilePic);
            }
        } else {
            unRegisteredMember = new Member(userId, profilePic);
            members.add(unRegisteredMember);
        }
    }

    public void addMember(Long userId, String username, String displayName, Strings.Rank rank){
        Member unRegisteredMember = findMember(userId);

        if(unRegisteredMember != null){
            if(!unRegisteredMember.isReady()) {
                unRegisteredMember.setData(username, displayName, rank);
            }
        }else{
            unRegisteredMember = new Member(userId, username, displayName, rank);
            members.add(unRegisteredMember);
        }
    }

    public Member getMember(long userId){
        return findMember(userId);
    }

    public void addMembersByRanks(PojoPermisionUsers members){
        if (members != null) {
            MeInfo meInfo = MeInfo.getInstance();
            long myId = meInfo.getUserId();

            if (members.getOWNER() != null) {
                for (POJOuser u : members.getOWNER()) {
                    addMember(u.getId(), u.getUsername(), u.getDisplayName(), Strings.Rank.OWNER);
                    if(u.getId() == myId){
                        Log.e("hey", "im34 owner");
                        meInfo.setRankInCurrentGroup(Strings.Rank.OWNER);
                    }
                }
            }
            if (members.getMODERATOR() != null) {
                for (POJOuser u : members.getMODERATOR()) {
                    addMember(u.getId(), u.getUsername(), u.getDisplayName(), Strings.Rank.MODERATOR);
                    if(u.getId() == myId){
                        Log.e("hey", "im34 moderator");
                        meInfo.setRankInCurrentGroup(Strings.Rank.MODERATOR);
                    }
                }
            }if (members.getUSER() != null) {
                for (POJOuser u : members.getUSER()) {
                    addMember(u.getId(), u.getUsername(), u.getDisplayName(), Strings.Rank.USER);
                    if(u.getId() == myId){
                        Log.e("hey", "im34 user");
                        meInfo.setRankInCurrentGroup(Strings.Rank.USER);
                    }
                }
            }if (members.getNULL() != null) {
                for (POJOuser u : members.getNULL()) {
                    addMember(u.getId(), u.getUsername(), u.getDisplayName(), Strings.Rank.NULL);
                    if(u.getId() == myId){
                        Log.e("hey", "im34 null");
                        meInfo.setRankInCurrentGroup(Strings.Rank.NULL);
                    }
                }
            }
        }
        setupPhase++;
    }

    public void addMembersByProfilePics(Map<Long, POJOMembersProfilePic> profilePics){
        for(Map.Entry<Long, POJOMembersProfilePic> entry : profilePics.entrySet()) {
            Log.e("hey",  entry.getKey() + ": " + entry.getValue().getData());
            Long userId = entry.getKey();
            addMember(userId, entry.getValue().getData());
        }
        setupPhase++;
    }


    private Member findMember(long userId){
        for(Member m : members){
            if(m.getUserId() == userId){
                return m;
            }
        }
        return null;
    }

    public void clear(){
        members.clear();
        setupPhase = 0;
    }
}
