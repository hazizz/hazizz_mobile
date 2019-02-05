package com.hazizz.droid.Fragments.GroupTabs;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.hazizz.droid.Activities.MainActivity;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOMembersProfilePic;
import com.hazizz.droid.Communication.Requests.GetGroupMembersProfilePic;
import com.hazizz.droid.Communication.Requests.LeaveGroup;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Manager;
import com.hazizz.droid.Transactor;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.R;

import java.util.EnumMap;
import java.util.HashMap;

public class GroupTabFragment extends Fragment {

    private View v;

   // ArrayList<POJOMembersProfilePic> userProfilePics;

    public PagerAdapter adapter;

    public static int groupId;
    public static String groupName;
    private int startingTab;

    private ViewPager viewPager;

    CustomResponseHandler rh = new CustomResponseHandler() {
        @Override
        public void onSuccessfulResponse() {
            Transactor.fragmentGroups(getFragmentManager().beginTransaction());
        }
    };

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_tabgroup, container, false);
        Log.e("hey", "GroupTab fragment created");

        Manager.GroupRankManager.clear();

        groupId = getArguments().getInt("groupId");
        getGroupMemberProfilePics();
        groupName = getArguments().getString("groupName");
        getActivity().setTitle(getResources().getString(R.string.group_)+ " " + groupName);
        Manager.GroupManager.setGroupId(groupId);
        Manager.GroupManager.setGroupName(groupName);
        startingTab = getArguments().getInt("startingTab");


        TabLayout tabLayout = (TabLayout) v.findViewById(R.id.tab_layout);
        tabLayout.setTabMode(TabLayout.MODE_SCROLLABLE);

        tabLayout.addTab(tabLayout.newTab().setText(R.string.tasks));
        tabLayout.addTab(tabLayout.newTab().setText(R.string.announcements));
        tabLayout.addTab(tabLayout.newTab().setText(R.string.subjects));
        tabLayout.addTab(tabLayout.newTab().setText(R.string.groupMembers));
        tabLayout.setTabGravity(TabLayout.GRAVITY_FILL);
      //  tabLayout.setcur
       // tabLayout.setCu

        viewPager = (ViewPager) v.findViewById(R.id.pager);
        adapter = new PagerAdapter
                (getActivity().getSupportFragmentManager(), tabLayout.getTabCount());
        adapter.giveArgs(groupId, groupName);

        viewPager.setOffscreenPageLimit(3);
    //    viewPager.setCurrent
       // bottomBar.setDefaultTab(R.id.tab_default);
        viewPager.setAdapter(adapter);
        viewPager.addOnPageChangeListener(new TabLayout.TabLayoutOnPageChangeListener(tabLayout));
        tabLayout.setOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
                viewPager.setCurrentItem(tab.getPosition());
                ((MainActivity)getActivity()).onTabSelected(adapter.getItem(viewPager.getCurrentItem()));
            }
            @Override
            public void onTabUnselected(TabLayout.Tab tab) {

            }
            @Override
            public void onTabReselected(TabLayout.Tab tab) {

            }
        });
        viewPager.setCurrentItem(startingTab, true);

        return v;
    }

    @Override
    public void onDestroyView() {
        Log.e("hey", "left group");
        super.onDestroyView();
        Manager.GroupManager.leftGroup();
    }

    public Fragment getCurrentFrag(){
        if(viewPager != null){
            return adapter.getItem(viewPager.getCurrentItem());
        }else {
          //  return adapter.getItem(viewPager.getCurrentItem());
            Log.e("hey", "returned this");
           // return adapter.getItem(0);
            return this;
        }
    }

    public void setTab(int i){
        viewPager.setCurrentItem(i, true);
    }

    public void leaveGroup(){
        MiddleMan.newRequest(new LeaveGroup(getActivity(), rh, groupId));
    }

    public void getGroupMemberProfilePics() {
        CustomResponseHandler responseHandler = new CustomResponseHandler() {
            @Override
            public void onPOJOResponse(Object response) {
                Manager.ProfilePicManager.setCurrentGroupMembersProfilePic((HashMap<Integer, POJOMembersProfilePic>)response, groupId);
                Log.e("hey", "got response");
            }
        };
        EnumMap<Strings.Path, Object> vars = new EnumMap<>(Strings.Path.class);
        vars.put(Strings.Path.GROUPID, Integer.toString(groupId));
        MiddleMan.newRequest(new GetGroupMembersProfilePic(getActivity(),responseHandler, groupId));
    }
}
