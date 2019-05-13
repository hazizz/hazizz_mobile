package com.hazizz.droid.fragments.GroupTabs;

import android.app.Activity;
import android.app.AlertDialog;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import com.hazizz.droid.activities.BaseActivity;
import com.hazizz.droid.cache.CurrentGroup;

import com.hazizz.droid.communication.requests.LeaveGroup;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.fragments.ParentFragment.ParentFragment;
import com.hazizz.droid.fragments.ParentFragment.TabFragment;
import com.hazizz.droid.listeners.GenericListener;
import com.hazizz.droid.listeners.OnBackPressedListener;
import com.hazizz.droid.navigation.Transactor;
import com.hazizz.droid.communication.MiddleMan;
import com.hazizz.droid.R;
import com.hazizz.droid.manager.MenuManager;

public class GroupTabFragment extends ParentFragment {

    public PagerAdapter adapter;

    public static int groupId;
    public static String groupName;
    private int startingTab;

    private ViewPager viewPager;

    private Menu menu;


    public Activity activity;

    public static CurrentGroup currentGroup;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_tabgroup, container, false);
        Log.e("hey", "GroupTab fragment created");

        activity = getActivity();

        groupId = getArguments().getInt(Transactor.KEY_GROUPID);
        groupName = getArguments().getString(Transactor.KEY_GROUPNAME);

        currentGroup = CurrentGroup.getInstance();
        currentGroup.setGroup(getActivity(), groupId, groupName, new GenericListener() {
            @Override
            public void execute(){

                startingTab = getArguments().getInt(Transactor.KEY_STARTINGTAB);

                TabLayout tabLayout = (TabLayout) v.findViewById(R.id.tab_layout);
                tabLayout.setTabMode(TabLayout.MODE_SCROLLABLE);

                tabLayout.addTab(tabLayout.newTab().setText(R.string.tasks));
                tabLayout.addTab(tabLayout.newTab().setText(R.string.announcements));
                tabLayout.addTab(tabLayout.newTab().setText(R.string.subjects));
                tabLayout.addTab(tabLayout.newTab().setText(R.string.groupMembers));
                tabLayout.setTabGravity(TabLayout.GRAVITY_FILL);

                viewPager = (ViewPager) v.findViewById(R.id.pager);
                adapter = new PagerAdapter
                        (getActivity().getSupportFragmentManager(), tabLayout.getTabCount());
                adapter.giveArgs(groupId, groupName);

                viewPager.setOffscreenPageLimit(5);

                // bottomBar.setDefaultTab(R.id.tab_default);
                viewPager.setAdapter(adapter);
                viewPager.addOnPageChangeListener(new TabLayout.TabLayoutOnPageChangeListener(tabLayout));
                tabLayout.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
                    @Override
                    public void onTabSelected(TabLayout.Tab tab) {
                        viewPager.setCurrentItem(tab.getPosition());

                        TabFragment tabFragment = (TabFragment) adapter.getItem(viewPager.getCurrentItem());
                        tabFragment.onTabSelected();
                    }
                    @Override public void onTabUnselected(TabLayout.Tab tab) { }
                    @Override public void onTabReselected(TabLayout.Tab tab) { }
                });
                viewPager.setCurrentItem(startingTab, true);
            }
        });

        fragmentSetup(((BaseActivity)getActivity()));
        setOnBackPressedListener(new OnBackPressedListener() {
            @Override
            public void onBackPressed() {
                Transactor.fragmentMain(getFragmentManager().beginTransaction());
            }
        });

        setTitle(getResources().getString(R.string.group_)+ " " + groupName);

        return v;
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        this.menu = menu;
        menu.clear();

        inflater.inflate(R.menu.menu_group, menu);

        MenuItem leaveGroupItem = menu.findItem(R.id.action_leaveGroup);

        MenuManager.changeItemTextColor(getContext(), leaveGroupItem, R.color.colorAccent);

        super.onCreateOptionsMenu(menu, inflater);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        Log.e("hey", "asd3: clicked options item");
        switch (item.getItemId()){
            case R.id.action_leaveGroup:
                Log.e("hey", "asd3: leave group");
                AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(getContext());
                alertDialogBuilder.setTitle(R.string.leave_group);
                alertDialogBuilder
                        .setMessage(R.string.areyousure_leave_group)
                        .setCancelable(true)
                        .setPositiveButton(R.string.yes, (dialog, id) -> {
                            MiddleMan.newRequest(new LeaveGroup(getActivity(), new CustomResponseHandler() {
                                @Override
                                public void onSuccessfulResponse() {
                                    Transactor.fragmentMain(getFragmentManager().beginTransaction());
                                    Toast.makeText(getContext(), R.string.leaveGroup_successful, Toast.LENGTH_LONG).show();
                                }
                            }, groupId));
                            dialog.cancel();
                        })
                        .setNegativeButton(R.string.no, (dialog, id) -> {
                            dialog.cancel();
                        });
                AlertDialog alertDialog = alertDialogBuilder.create();
                alertDialog.show();
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onDestroyView() {
        menu.clear();
        super.onDestroyView();
    }

    public Fragment getCurrentFrag(){
        if(viewPager != null){
            return adapter.getItem(viewPager.getCurrentItem());
        }else {
            Log.e("hey", "returned this");
            return this;
        }
    }

    public void setTab(int i){
        viewPager.setCurrentItem(i, true);
    }
}
