package com.hazizz.droid.cache;

import android.util.Log;

import com.hazizz.droid.cache.MeInfo.MeInfo;
import com.hazizz.droid.communication.Strings;
import com.hazizz.droid.communication.responsePojos.PojoMembersProfilePic;
import com.hazizz.droid.communication.responsePojos.PojoPermisionUsers;
import com.hazizz.droid.communication.responsePojos.PojoUser;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CurrentMembersManager {

    // egy member csak userId-val jöhet létre

    List<Member> members = new ArrayList<>();

    PojoPermisionUsers usersData;
    HashMap<Long, PojoMembersProfilePic> profilePics;


    short setupPhase = 0;


    public boolean isReady(){
        return setupPhase >= 2;
    }

    public List<Member> getMembers(){
        return members;
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
                for (PojoUser u : members.getOWNER()) {
                    addMember(u.getId(), u.getUsername(), u.getDisplayName(), Strings.Rank.OWNER);
                    if(u.getId() == myId){
                        Log.e("hey", "im34 owner");
                        meInfo.setRankInCurrentGroup(Strings.Rank.OWNER);
                    }
                }
            }
            if (members.getMODERATOR() != null) {
                for (PojoUser u : members.getMODERATOR()) {
                    addMember(u.getId(), u.getUsername(), u.getDisplayName(), Strings.Rank.MODERATOR);
                    if(u.getId() == myId){
                        Log.e("hey", "im34 moderator");
                        meInfo.setRankInCurrentGroup(Strings.Rank.MODERATOR);
                    }
                }
            }if (members.getUSER() != null) {
                for (PojoUser u : members.getUSER()) {
                    addMember(u.getId(), u.getUsername(), u.getDisplayName(), Strings.Rank.USER);
                    if(u.getId() == myId){
                        Log.e("hey", "im34 user");
                        meInfo.setRankInCurrentGroup(Strings.Rank.USER);
                    }
                }
            }if (members.getNULL() != null) {
                for (PojoUser u : members.getNULL()) {
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

    public void addMembersByProfilePics(Map<Long, PojoMembersProfilePic> profilePics){
        for(Map.Entry<Long, PojoMembersProfilePic> entry : profilePics.entrySet()) {
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
