package com.indeed.hazizz.Fragments.GroupTabs;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import com.indeed.hazizz.PagerAdapter;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.indeed.hazizz.Activities.MainActivity;
import com.indeed.hazizz.R;

public class GroupTabFragment extends Fragment {

    private View v;

    private TextView textView_title;
    private PagerAdapter adapter;

    private int groupId;
    private String groupName;
    private int startingTab;

    private Fragment currentFrag;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_tabgroup, container, false);
        Log.e("hey", "GroupTab fragment created");

        groupId = getArguments().getInt("groupId");
        groupName = getArguments().getString("groupName");
        startingTab = getArguments().getInt("startingTab");

        textView_title = v.findViewById(R.id.textView_title);
        textView_title.setText("Csoport: " + groupName);
     //   ((MainActivity)getActivity()).onFragmentCreated();

        TabLayout tabLayout = (TabLayout) v.findViewById(R.id.tab_layout);
        tabLayout.addTab(tabLayout.newTab().setText("Feladatok"));
        tabLayout.addTab(tabLayout.newTab().setText("Tagok"));
        tabLayout.addTab(tabLayout.newTab().setText("Új feladat"));
        tabLayout.setTabGravity(TabLayout.GRAVITY_FILL);
      //  tabLayout.setcur
       // tabLayout.setCu

        final ViewPager viewPager = (ViewPager) v.findViewById(R.id.pager);
        adapter = new PagerAdapter
                (getFragmentManager(), tabLayout.getTabCount());
        adapter.giveArgs(groupId, groupName);
    //    viewPager.setCurrent
       // bottomBar.setDefaultTab(R.id.tab_default);
        viewPager.setAdapter(adapter);
        viewPager.addOnPageChangeListener(new TabLayout.TabLayoutOnPageChangeListener(tabLayout));
        tabLayout.setOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
                viewPager.setCurrentItem(tab.getPosition());
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
        return adapter.getCurrentFrag();
    }
}
