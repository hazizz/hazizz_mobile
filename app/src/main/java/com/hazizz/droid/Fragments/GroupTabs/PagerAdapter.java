package com.hazizz.droid.Fragments.GroupTabs;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.util.Log;

import com.hazizz.droid.Fragments.ParentFragment.TabFragment;
import com.hazizz.droid.Transactor;

public class PagerAdapter extends FragmentStatePagerAdapter {

    public static final int TASKS_TAB = 0;
    public static final int ANNOUNCEMENTS_TAB = 1;
    public static final int SUBJECTS_TAB = 2;
    public static final int GROUPMEMBERS_TAB = 3;

    int mNumOfTabs;

    private int groupId;
    private String groupName;

    private TabFragment currentFrag;

    public PagerAdapter(FragmentManager fm, int NumOfTabs) {
        super(fm);
        this.mNumOfTabs = NumOfTabs;
    }
    @Override
    public Fragment getItem(int position) {

        Bundle bundle;
        TabFragment frag;

        switch (position) {
            case TASKS_TAB:
                bundle = new Bundle();
                Log.e("hey", "pagerAdapter groupId: " + groupId);
                Log.e("hey", "changed tab");
                bundle.putInt(Transactor.KEY_GROUPID, groupId);
                bundle.putString(Transactor.KEY_GROUPNAME, groupName);
                frag = new GroupMainFragment();
                frag.setArguments(bundle);
                currentFrag = frag;
                return frag;

            case ANNOUNCEMENTS_TAB:
                Log.e("hey", "changed tab");
                bundle = new Bundle();
                bundle.putInt(Transactor.KEY_GROUPID, groupId);
                bundle.putString(Transactor.KEY_GROUPNAME, groupName);
                frag= new GroupAnnouncementFragment();
                frag.setArguments(bundle);
                currentFrag = frag;
                return frag;
            case SUBJECTS_TAB:
                Log.e("hey", "changed tab");
                bundle = new Bundle();
                bundle.putInt(Transactor.KEY_GROUPID, groupId);
                frag = new SubjectsFragment();
                frag.setArguments(bundle);

                currentFrag = frag;
                return frag;
            case GROUPMEMBERS_TAB:
            default:
                Log.e("hey", "changed tab");
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
