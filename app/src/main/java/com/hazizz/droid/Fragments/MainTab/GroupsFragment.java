package com.hazizz.droid.Fragments.MainTab;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.widget.SwipeRefreshLayout;
import android.util.Log;
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
import com.hazizz.droid.Listviews.GroupList.CustomAdapter;
import com.hazizz.droid.Listviews.GroupList.GroupItem;
import com.hazizz.droid.Manager;
import com.hazizz.droid.Transactor;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.R;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class GroupsFragment extends Fragment {

    private List<GroupItem> listGroup;
    private View v;
    private CustomAdapter adapter;
    private TextView textView_noContent;
    private TextView textView_title;

    private SwipeRefreshLayout sRefreshLayout;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_group, container, false);
        ((MainActivity)getActivity()).onFragmentCreated();

        createViewList();
        textView_noContent = v.findViewById(R.id.textView_noContent);
        textView_title = v.findViewById(R.id.textView_title);
        sRefreshLayout = v.findViewById(R.id.swipe_refresh_layout); sRefreshLayout.bringToFront();
        sRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                getGroups();
            }});

        getGroups();

        return v;
    }

    public void getGroups() {
        adapter.clear();
        CustomResponseHandler responseHandler = new CustomResponseHandler() {
            @Override
            public void onPOJOResponse(Object response) {
                textView_noContent.setVisibility(v.INVISIBLE);
                ArrayList<POJOgroup> castedListFullOfPojos = (ArrayList<POJOgroup>)response;
                listGroup.clear();
                if(!castedListFullOfPojos.isEmpty()) {
                    for (POJOgroup g : castedListFullOfPojos) {
                        listGroup.add(new GroupItem(R.drawable.ic_launcher_background, g.getUniqueName(), g.getId()));
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
            public void onEmptyResponse() {
                textView_noContent.setVisibility(v.VISIBLE);
                sRefreshLayout.setRefreshing(false);
            }
            @Override
            public void onNoConnection() {
                textView_noContent.setText(R.string.info_noInternetAccess);
                textView_noContent.setVisibility(View.VISIBLE);
                sRefreshLayout.setRefreshing(false);
            }
        };
        MiddleMan.newRequest(this.getActivity(),"getGroupsFromMe", null, responseHandler, null);
    }

    void createViewList(){
        listGroup = new ArrayList<>();

        ListView listView = (ListView)v.findViewById(R.id.listView1);

        adapter = new CustomAdapter(getActivity(), R.layout.list_item, listGroup);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                switch (Manager.DestManager.getDest()) {
                    case Manager.DestManager.TOCREATETASK:
                        Manager.GroupManager.setGroupId(((GroupItem) listView.getItemAtPosition(i)).getGroupId());
                        Manager.GroupManager.setGroupName(((GroupItem) listView.getItemAtPosition(i)).getGroupName());
                        Transactor.fragmentCreateTask(getFragmentManager().beginTransaction(), ((GroupItem) listView.getItemAtPosition(i)).getGroupId(), ((GroupItem) listView.getItemAtPosition(i)).getGroupName(), Manager.DestManager.TOMAIN);
                        break;
                    case Manager.DestManager.TOCREATEANNOUNCEMENT:
                        Manager.GroupManager.setGroupId(((GroupItem) listView.getItemAtPosition(i)).getGroupId());
                        Manager.GroupManager.setGroupName(((GroupItem) listView.getItemAtPosition(i)).getGroupName());
                        Transactor.fragmentCreateAnnouncement(getFragmentManager().beginTransaction(), ((GroupItem) listView.getItemAtPosition(i)).getGroupId(), ((GroupItem) listView.getItemAtPosition(i)).getGroupName(), Manager.DestManager.TOMAIN);
                        break;
                    case Manager.DestManager.TOMAIN:
                        Transactor.fragmentMainGroup(getFragmentManager().beginTransaction(), ((GroupItem) listView.getItemAtPosition(i)).getGroupId(), ((GroupItem) listView.getItemAtPosition(i)).getGroupName());
                        break;
                    default:
                        Transactor.fragmentMainGroup(getFragmentManager().beginTransaction(), ((GroupItem) listView.getItemAtPosition(i)).getGroupId(), ((GroupItem) listView.getItemAtPosition(i)).getGroupName());
                        break;
                }
            }
        });
    }
    public void toCreateGroup(FragmentManager fm){
        Transactor.fragmentCreateGroup(fm.beginTransaction());
    }
}
