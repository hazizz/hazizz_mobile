package com.hazizz.droid.Fragments.MainTab;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.hazizz.droid.Activities.MainActivity;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.POJO.Response.POJOgroup;
import com.hazizz.droid.Communication.Requests.GetGroupsFromMe;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Fragments.ParentFragment.ParentFragment;
import com.hazizz.droid.Listviews.GroupList.CustomAdapter;
import com.hazizz.droid.Listviews.GroupList.GroupItem;
import com.hazizz.droid.Manager;
import com.hazizz.droid.Transactor;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.R;

import java.util.ArrayList;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class GroupsFragment extends ParentFragment {

    private List<GroupItem> listGroup;
    private View v;
    private CustomAdapter adapter;
    private TextView textView_noContent;

    private int dest;

    private SwipeRefreshLayout sRefreshLayout;


    public enum Dest {
        TOCREATETASK(1),
        TOCREATEANNOUNCEMET(2);

        private int value;

        Dest(int value){
            this.value = value;
        }

        public int getValue() {
            return value;
        }
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_group, container, false);
        fragmentSetup();

        createViewList();
        textView_noContent = v.findViewById(R.id.textView_noContent);
        sRefreshLayout = v.findViewById(R.id.swipe_refresh_layout); sRefreshLayout.bringToFront();
        sRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                getGroups();
            }});
        sRefreshLayout.setColorSchemeColors(getResources().getColor(R.color.colorPrimaryDarkBlue), getResources().getColor(R.color.colorPrimaryLightBlue), getResources().getColor(R.color.colorPrimaryDarkBlue));
        getGroups();

        if(getArguments() != null){
            dest = getArguments().getInt(Transactor.KEY_DEST);
            if(dest != 0){
                ((MainActivity) getActivity()).hideFabs();
                setTitle(R.string.choose_group);
                return v;
            }
        }
        setTitle(R.string.title_fragment_groups);


        return v;
    }

    public void getGroups() {
        CustomResponseHandler responseHandler = new CustomResponseHandler() {
            @Override
            public void onPOJOResponse(Object response) {
                adapter.clear();
                textView_noContent.setVisibility(View.INVISIBLE);
                ArrayList<POJOgroup> castedListFullOfPojos = (ArrayList<POJOgroup>)response;
                listGroup.clear();
                if(!castedListFullOfPojos.isEmpty()) {
                    for (POJOgroup g : castedListFullOfPojos) {
                        listGroup.add(new GroupItem(R.drawable.ic_launcher_background, g.getName(), g.getId()));
                    }
                    adapter.notifyDataSetChanged();
                }else{
                    textView_noContent.setText(R.string.error_notMemberOfGroup);
                }
                sRefreshLayout.setRefreshing(false);
            }
            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                sRefreshLayout.setRefreshing(false);
            }
            @Override
            public void onErrorResponse(POJOerror error) {
                sRefreshLayout.setRefreshing(false);
            }
            @Override
            public void onNoConnection() {
                textView_noContent.setText(R.string.info_noInternetAccess);
                textView_noContent.setVisibility(View.VISIBLE);
                sRefreshLayout.setRefreshing(false);
            }
        };
        MiddleMan.newRequest(new GetGroupsFromMe(getActivity(),responseHandler));
    }

    void createViewList(){
        listGroup = new ArrayList<>();

        ListView listView = v.findViewById(R.id.listView1);

        adapter = new CustomAdapter(getActivity(), R.layout.list_item, listGroup);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                int groupId = ((GroupItem) listView.getItemAtPosition(i)).getGroupId();
                String groupName = ((GroupItem) listView.getItemAtPosition(i)).getGroupName();
                if(Dest.TOCREATETASK.getValue() == dest) {
                    Transactor.fragmentCreateTask(getFragmentManager().beginTransaction(), groupId, groupName, Strings.Dest.TOMAIN);
                }else if(Dest.TOCREATEANNOUNCEMET.getValue() == dest){
                    Transactor.fragmentCreateAnnouncement(getFragmentManager().beginTransaction(), groupId, groupName, Strings.Dest.TOMAIN);
                }else{
                    Transactor.fragmentMainGroup(getFragmentManager().beginTransaction(), groupId, groupName);
                }
            }
        });
    }
    public void toCreateGroup(FragmentManager fm){
        Transactor.fragmentCreateGroup(fm.beginTransaction());
    }
}
