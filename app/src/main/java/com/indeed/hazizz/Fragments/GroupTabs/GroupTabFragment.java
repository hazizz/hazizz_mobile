package com.indeed.hazizz.Fragments.GroupTabs;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;

import com.indeed.hazizz.Activities.MainActivity;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOMembersProfilePic;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;

import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.indeed.hazizz.Communication.Strings;
import com.indeed.hazizz.Manager;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.util.EnumMap;
import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class GroupTabFragment extends Fragment {

    private View v;

   // ArrayList<POJOMembersProfilePic> userProfilePics;

    private TextView textView_title;
    public PagerAdapter adapter;

    public static int groupId;
    public static String groupName;
    private int startingTab;

    private ViewPager viewPager;

    CustomResponseHandler rh = new CustomResponseHandler() {
        @Override
        public void onResponse(HashMap<String, Object> response) { }
        @Override
        public void onPOJOResponse(Object response) { }
        @Override
        public void onFailure(Call<ResponseBody> call, Throwable t) { }
        @Override
        public void onErrorResponse(POJOerror error) { }
        @Override
        public void onEmptyResponse() { }
        @Override
        public void onSuccessfulResponse() {
            Transactor.fragmentGroups(getFragmentManager().beginTransaction());        }
        @Override
        public void onNoConnection() { }
    };

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_tabgroup, container, false);
        Log.e("hey", "GroupTab fragment created");

       // Manager.DestManager.resetDest();


        groupId = getArguments().getInt("groupId");
        getGroupMemberProfilePics();
        groupName = getArguments().getString("groupName");
        Manager.GroupManager.setGroupId(groupId);
        Manager.GroupManager.setGroupName(groupName);
        startingTab = getArguments().getInt("startingTab");

        textView_title = v.findViewById(R.id.textView_title);
        textView_title.append(" " + groupName);
     //   ((MainActivity)getActivity()).onFragmentCreated();

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
        EnumMap<Strings.Path, Object> vars = new EnumMap<>(Strings.Path.class);
        vars.put(Strings.Path.GROUPID, Integer.toString(groupId));
        MiddleMan.newRequest(getActivity(), "leaveGroup", null, rh, vars);
    }

    public void getGroupMemberProfilePics() {
        CustomResponseHandler responseHandler = new CustomResponseHandler() {
            @Override
            public void onResponse(HashMap<String, Object> response) { }
            @Override
            public void onPOJOResponse(Object response) {
                Manager.ProfilePicManager.setCurrentGroupMembersProfilePic((HashMap<Integer, POJOMembersProfilePic>)response, groupId);
                Log.e("hey", "got response");
            }
            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                Log.e("hey", "4");
                Log.e("hey", "got here onFailure");
            }
            @Override
            public void onErrorResponse(POJOerror error) {
                Log.e("hey", "onErrorResponse");
            }
            @Override
            public void onEmptyResponse() { }
            @Override
            public void onSuccessfulResponse() { }
            @Override
            public void onNoConnection() { }
        };
        EnumMap<Strings.Path, Object> vars = new EnumMap<>(Strings.Path.class);
        vars.put(Strings.Path.GROUPID, Integer.toString(groupId));
        MiddleMan.newRequest(this.getActivity(),"getGroupMembersProfilePic", null, responseHandler, vars);
    }
}
