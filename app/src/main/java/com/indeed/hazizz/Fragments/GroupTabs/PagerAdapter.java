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
        Fragment frag;

        switch (position) {
            case 0:
                bundle = new Bundle();
                Log.e("hey", "pagerAdapter groupId: " + groupId);
                bundle.putInt("groupId", groupId);
                bundle.putString("groupName", groupName);
                frag = new GroupMainFragment();
                frag.setArguments(bundle);
                currentFrag = frag;
                return frag;

            case 1:
                bundle = new Bundle();
                bundle.putInt("groupId", groupId);
                bundle.putString("groupName", groupName);
                frag= new GroupAnnouncementFragment();
                frag.setArguments(bundle);
                currentFrag = frag;
                return frag;
            case 2:
                bundle = new Bundle();
                bundle.putInt("groupId", groupId);
                frag = new SubjectsFragment();
                frag.setArguments(bundle);

                currentFrag = frag;
                return frag;
            case 3:
                bundle = new Bundle();
                bundle.putInt("groupId", groupId);
                bundle.putString("groupName", groupName);
                frag = new GetGroupMembersFragment();
                frag.setArguments(bundle);

                currentFrag = frag;
                return frag;

            default:
                bundle = new Bundle();
                Log.e("hey", "pagerAdapter groupId: " + groupId);
                bundle.putInt("groupId", groupId);
                bundle.putString("groupName", groupName);
                frag = new GroupMainFragment();
                frag.setArguments(bundle);
                currentFrag = frag;
                return frag;
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
