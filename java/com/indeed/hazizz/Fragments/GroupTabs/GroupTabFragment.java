package com.indeed.hazizz.Fragments.GroupTabs;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;

import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.PagerAdapter;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class GroupTabFragment extends Fragment {

    private View v;

    private TextView textView_title;
    public PagerAdapter adapter;

    private int groupId;
    private String groupName;
    private int startingTab;

    private ViewPager viewPager;
    private Fragment currentFrag;

    CustomResponseHandler rh = new CustomResponseHandler() {
        @Override
        public void onResponse(HashMap<String, Object> response) {

        }

        @Override
        public void onPOJOResponse(Object response) {

        }

        @Override
        public void onFailure(Call<ResponseBody> call, Throwable t) {

        }

        @Override
        public void onErrorResponse(POJOerror error) {

        }

        @Override
        public void onEmptyResponse() {

        }

        @Override
        public void onSuccessfulResponse() {
            Transactor.fragmentGroups(getFragmentManager().beginTransaction(), false);        }

        @Override
        public void onNoConnection() {

        }
    };

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

        viewPager = (ViewPager) v.findViewById(R.id.pager);
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

    public void setTab(int i){
        viewPager.setCurrentItem(i, true);
    }

    public void leaveGroup(){
        HashMap<String, String> vars = new HashMap<>();
        vars.put("groupId", Integer.toString(groupId));
      //  MiddleMan.request.leaveGroup(getContext(), null, rh, vars);
        MiddleMan.newRequest(getContext(), "leaveGroup", null, rh, vars);

    }
}
