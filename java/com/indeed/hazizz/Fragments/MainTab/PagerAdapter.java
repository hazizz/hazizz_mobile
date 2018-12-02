package com.indeed.hazizz.Fragments.MainTab;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;

import com.indeed.hazizz.Fragments.CreateTaskFragment;
import com.indeed.hazizz.Fragments.GetGroupMembersFragment;
import com.indeed.hazizz.Fragments.GroupsFragment;

public class PagerAdapter extends FragmentStatePagerAdapter {

    int mNumOfTabs;
    private Fragment currentFrag;

    public PagerAdapter(FragmentManager fm, int NumOfTabs) {
        super(fm);
        this.mNumOfTabs = NumOfTabs;
    }

    @Override
    public Fragment getItem(int position) {

        Bundle bundle;
        switch (position) {
            case 0:
                bundle = new Bundle();
                MainFragment frag0 = new MainFragment();
                frag0.setArguments(bundle);

                currentFrag = frag0;
                return frag0;
            case 1:
                bundle = new Bundle();
                MainAnnouncementFragment frag = new MainAnnouncementFragment();
                frag.setArguments(bundle);

                currentFrag = frag;
                return frag;
            case 2:
                bundle = new Bundle();
                GroupsFragment frag2 = new GroupsFragment();
                frag2.setArguments(bundle);

                currentFrag = frag2;
                return frag2;

          /*  case 3:
                bundle = new Bundle();
                bundle.putInt("groupId", groupId);
                bundle.putString("groupName", groupName);
                CreateTaskFragment frag3 = new CreateTaskFragment();
                frag3.setArguments(bundle);

                currentFrag = frag3;
                return frag3; */
            default:
                bundle = new Bundle();
                MainFragment frag5 = new MainFragment();
                frag5.setArguments(bundle);

                currentFrag = frag5;
                return frag5;
        }
    }
    @Override
    public int getCount() {
        return mNumOfTabs;
    }

    public Fragment getCurrentFrag(){
        return currentFrag;
    }

}

