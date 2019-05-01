package com.hazizz.droid.fragments.ThéraFrags.Setup.schedulesFragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.util.Log;

import com.hazizz.droid.fragments.GroupTabs.GetGroupMembersFragment;
import com.hazizz.droid.fragments.GroupTabs.GroupAnnouncementFragment;
import com.hazizz.droid.fragments.GroupTabs.GroupMainFragment;
import com.hazizz.droid.fragments.GroupTabs.SubjectsFragment;
import com.hazizz.droid.fragments.ParentFragment.TabFragment;
import com.hazizz.droid.navigation.Transactor;

public class PagerAdapter extends FragmentStatePagerAdapter {

    public static final int MONDAY_TAB = 0;
    public static final int TUESDAY_TAB = 1;
    public static final int WEDNESDAY_TAB = 2;
    public static final int THURSDAY_TAB = 3;
    public static final int FRIDAY_TAB = 4;

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
            case MONDAY_TAB:
                bundle = new Bundle();
                Log.e("hey", "pagerAdapter groupId: " + groupId);
                Log.e("hey", "changed tab");
                frag = new GroupMainFragment();
                frag.setArguments(bundle);
                currentFrag = frag;
                return frag;

            case TUESDAY_TAB:
                Log.e("hey", "changed tab");
                bundle = new Bundle();
                bundle.putInt(Transactor.KEY_GROUPID, groupId);
                bundle.putString(Transactor.KEY_GROUPNAME, groupName);
                frag= new GroupAnnouncementFragment();
                frag.setArguments(bundle);
                currentFrag = frag;
                return frag;
            case WEDNESDAY_TAB:
                Log.e("hey", "changed tab");
                bundle = new Bundle();
                frag = new SubjectsFragment();
                frag.setArguments(bundle);

                currentFrag = frag;
                return frag;
            case THURSDAY_TAB:
                Log.e("hey", "changed tab");
                bundle = new Bundle();
                frag = new GetGroupMembersFragment();
                frag.setArguments(bundle);

                currentFrag = frag;
                return frag;

            case FRIDAY_TAB:
            default:
                Log.e("hey", "changed tab");
                bundle = new Bundle();
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

