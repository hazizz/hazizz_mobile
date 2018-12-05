package com.indeed.hazizz.Fragments;

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

import com.indeed.hazizz.Activities.MainActivity;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Fragments.MainTab.PagerAdapter;
import com.indeed.hazizz.Manager;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class MainTabFragment extends Fragment{

    private View v;

    private TextView textView_title;
    public PagerAdapter adapter;

    private int startingTab;
    private String dest;

    private ViewPager viewPager;
    private Fragment currentTab;

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
        v = inflater.inflate(R.layout.fragment_tabmain, container, false);
        Log.e("hey", "GroupTab fragment created");

       // savedInstanceState.putBoolean();

        startingTab = getArguments().getInt("startingTab");

        textView_title = v.findViewById(R.id.textView_title);
        //   ((MainActivity)getActivity()).onFragmentCreated();

        TabLayout tabLayout = (TabLayout) v.findViewById(R.id.tab_layout);

        tabLayout.addTab(tabLayout.newTab().setText("Feladatok"));
        tabLayout.addTab(tabLayout.newTab().setText("Bejegyzések"));
        tabLayout.addTab(tabLayout.newTab().setText("Csoportok"));
        tabLayout.setTabGravity(TabLayout.GRAVITY_FILL);
        //  tabLayout.setcur
        // tabLayout.setCu

        viewPager = (ViewPager) v.findViewById(R.id.pager);
        adapter = new PagerAdapter
                (getActivity().getSupportFragmentManager(), tabLayout.getTabCount());
        //adapter.giveArgs(groupId, groupName);

        //    viewPager.setCurrent
        // bottomBar.setDefaultTab(R.id.tab_default);
        viewPager.setAdapter(adapter);
        viewPager.addOnPageChangeListener(new TabLayout.TabLayoutOnPageChangeListener(tabLayout));
        tabLayout.setOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
             /*   if(adapter.getItem(viewPager.getCurrentItem()).getClass() == GroupsFragment.class) {
                    adapter.setDest(dest);
                }else{
                    adapter.setDest("");
                } */
               // Manager.DestManager.setDest(Manager.DestManager.TOMAIN);
                viewPager.setCurrentItem(tab.getPosition());
                ((MainActivity)getActivity()).onTabSelected(adapter.getItem(viewPager.getCurrentItem()));
                currentTab = adapter.getItem(viewPager.getCurrentItem());
            }
            @Override
            public void onTabUnselected(TabLayout.Tab tab) {
             //   Manager.DestManager.setDest(Manager.DestManager.TOMAIN);
                if(currentTab instanceof GroupsFragment){
                    Manager.DestManager.setDest(Manager.DestManager.TOMAIN);
                }

            }
            @Override
            public void onTabReselected(TabLayout.Tab tab) {

            }
        });

        viewPager.setOffscreenPageLimit(3);

        viewPager.setCurrentItem(startingTab, true);

        return v;
    }

    public Fragment getCurrentFrag(){
        if(viewPager != null){
            return adapter.getItem(viewPager.getCurrentItem());
        }else{
            Log.e("hey", "returned this");
            return this;
        }
        // return adapter.getCurrentFrag();
    }
    public void setTab(int i){
        viewPager.setCurrentItem(i, true);
    }
}
