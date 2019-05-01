package com.hazizz.droid.fragments.ThéraFrags.Setup.schedulesFragments;

import android.app.Activity;
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

import com.hazizz.droid.cache.CurrentGroup;
import com.hazizz.droid.fragments.ParentFragment.ParentFragment;
import com.hazizz.droid.fragments.ParentFragment.TabFragment;
import com.hazizz.droid.listeners.OnBackPressedListener;
import com.hazizz.droid.R;
import com.hazizz.droid.manager.MenuManager;
import com.hazizz.droid.navigation.Transactor;

public class TheraSchedulesTabFragmentHoster extends ParentFragment {

    public PagerAdapter adapter;

    private int startingTab;

    private ViewPager viewPager;

    private Menu menu;


    public Activity activity;

    public static CurrentGroup currentGroup;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_schedules_tab_fragment_hoster, container, false);
        Log.e("hey", "GroupTab fragment created");

        activity = getActivity();
        fragmentSetup(R.string.thera_schedules);

        setOnBackPressedListener(new OnBackPressedListener() {
            @Override
            public void onBackPressed() {
                Transactor.fragmentThMain(getFragmentManager().beginTransaction());
            }
        });

        if(getArguments() != null){
            startingTab = getArguments().getInt(Transactor.KEY_TABINDEX);
            TabLayout tabLayout = (TabLayout) v.findViewById(R.id.tab_layout);
            tabLayout.setTabMode(TabLayout.MODE_SCROLLABLE);

            String[] days = getResources().getStringArray(R.array.days);
            tabLayout.addTab(tabLayout.newTab().setText(days[0]));
            tabLayout.addTab(tabLayout.newTab().setText(days[1]));
            tabLayout.addTab(tabLayout.newTab().setText(days[2]));
            tabLayout.addTab(tabLayout.newTab().setText(days[3]));
            tabLayout.addTab(tabLayout.newTab().setText(days[4]));
            tabLayout.setTabGravity(TabLayout.GRAVITY_FILL);

            viewPager = (ViewPager) v.findViewById(R.id.pager);
            adapter = new PagerAdapter
                    (getActivity().getSupportFragmentManager(), tabLayout.getTabCount());

            viewPager.setOffscreenPageLimit(5);

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
