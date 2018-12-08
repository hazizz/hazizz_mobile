package com.indeed.hazizz.Fragments.GroupTabs;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.util.Log;

public class PagerAdapter extends FragmentStatePagerAdapter {
    int mNumOfTabs;

    private int groupId;
    private String groupName;

    private Fragment currentFrag;

    public PagerAdapter(FragmentManager fm, int NumOfTabs) {
        super(fm);
        this.mNumOfTabs = NumOfTabs;
    }
    @Override
    public Fragment getItem(int position) {

        Bundle bundle = new Bundle();


        switch (position) {
            case 0:
                bundle = new Bundle();
                Log.e("hey", "pagerAdapter groupId: " + groupId);
                bundle.putInt("groupId", groupId);
                bundle.putString("groupName", groupName);
                GroupMainFragment frag = new GroupMainFragment();
                frag.setArguments(bundle);
                currentFrag = frag;
                return frag;

            case 1:
                bundle = new Bundle();
                bundle.putInt("groupId", groupId);
                bundle.putString("groupName", groupName);
                GroupAnnouncementFragment frag0 = new GroupAnnouncementFragment();
                frag0.setArguments(bundle);
                currentFrag = frag0;
                return frag0;
            case 2:
                bundle = new Bundle();
                bundle.putInt("groupId", groupId);
                bundle.putString("groupName", groupName);
                GetGroupMembersFragment frag2 = new GetGroupMembersFragment();
                frag2.setArguments(bundle);

                currentFrag = frag2;
                return frag2;
            default:
                bundle = new Bundle();
                Log.e("hey", "pagerAdapter groupId: " + groupId);
                bundle.putInt("groupId", groupId);
                bundle.putString("groupName", groupName);
                GroupMainFragment frag3 = new GroupMainFragment();
                frag3.setArguments(bundle);
                currentFrag = frag3;
                return frag3;
        }
    }

    @Override
    public int getCount() {
        return mNumOfTabs;
    }

    public Fragment getCurrentFrag(){
        return currentFrag;
    }

    public void giveArgs(int groupId, String groupName){
        this.groupId = groupId;
        this.groupName = groupName;
    }
}
