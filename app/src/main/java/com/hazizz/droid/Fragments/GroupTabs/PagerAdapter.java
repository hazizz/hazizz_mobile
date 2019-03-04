package com.hazizz.droid.Fragments.GroupTabs;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.util.Log;

import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Transactor;

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

        Bundle bundle;
        Fragment frag;

        switch (position) {
            case 0:
                bundle = new Bundle();
                Log.e("hey", "pagerAdapter groupId: " + groupId);
                bundle.putInt(Transactor.KEY_GROUPID, groupId);
                bundle.putString(Transactor.KEY_GROUPNAME, groupName);
                frag = new GroupMainFragment();
                frag.setArguments(bundle);
                currentFrag = frag;
                return frag;

            case 1:
                bundle = new Bundle();
                bundle.putInt(Transactor.KEY_GROUPID, groupId);
                bundle.putString(Transactor.KEY_GROUPNAME, groupName);
                frag= new GroupAnnouncementFragment();
                frag.setArguments(bundle);
                currentFrag = frag;
                return frag;
            case 2:
                bundle = new Bundle();
                bundle.putInt(Transactor.KEY_GROUPID, groupId);
                frag = new SubjectsFragment();
                frag.setArguments(bundle);

                currentFrag = frag;
                return frag;
            case 3:
            default:
                bundle = new Bundle();
                bundle.putInt(Transactor.KEY_GROUPID, groupId);
                bundle.putString(Transactor.KEY_GROUPNAME, groupName);
                frag = new GetGroupMembersFragment();
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
