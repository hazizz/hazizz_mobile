package com.indeed.hazizz.Fragments;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.indeed.hazizz.Activities.MainActivity;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.POJO.Response.POJOgroup;
import com.indeed.hazizz.Communication.Requests.Request;
import com.indeed.hazizz.FragTag;
import com.indeed.hazizz.Listviews.GroupList.CustomAdapter;
import com.indeed.hazizz.Listviews.GroupList.GroupItem;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class GroupsFragment extends Fragment {

    public List<Integer> groupIDs;
    public List<POJOgroup> groups;
    private List<GroupItem> listGroup;
    private View v;
    private CustomAdapter adapter;
    private TextView textView_noContent;

    private boolean destCreateTask = false;


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_group, container, false);
        ((MainActivity)getActivity()).onFragmentCreated();
        Log.e("hey", "im here lol");
        Log.e("hey", "groups fragment created");
        groups = new ArrayList<POJOgroup>();
        //groupIDs = getArguments().getIntegerArrayList("groupIds");
       // groups = getGroups(groupIDs);
        createViewList();
        getGroups();

        textView_noContent = v.findViewById(R.id.textView_noContent);

        return v;
    }

    public void getGroups() {
        Log.e("hey", "atleast here 2");
        CustomResponseHandler responseHandler = new CustomResponseHandler() {
            @Override
            public void onResponse(HashMap<String, Object> response) {

            }

            @Override
            public void onPOJOResponse(Object response) {
                ArrayList<POJOgroup> castedListFullOfPojos = (ArrayList<POJOgroup>)response;
                for(POJOgroup g : castedListFullOfPojos){
                    listGroup.add(new GroupItem(R.drawable.ic_launcher_background, g.getName(), g.getId()));
                }

                adapter.notifyDataSetChanged();
                Log.e("hey", "got response");
            }

            @Override
            public void onFailure() {
                Log.e("hey", "4");
                Log.e("hey", "got here onFailure");
            }

            @Override
            public void onErrorResponse(POJOerror error) {
                Log.e("hey", "onErrorResponse");
            }

            @Override
            public void onEmptyResponse() {
                textView_noContent.setVisibility(v.VISIBLE);
            }

            @Override
            public void onSuccessfulResponse() {

            }
        };
        MiddleMan.newRequest(this.getActivity(), "getGroupsFromMe", null, responseHandler, null);
    }

    void createViewList(){
        listGroup = new ArrayList<>();

        ListView listView = (ListView)v.findViewById(R.id.listView1);

        adapter = new CustomAdapter(getActivity(), R.layout.list_item, listGroup);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                if(destCreateTask) {
                    Transactor.fragmentCreateTask(getFragmentManager().beginTransaction(), ((GroupItem) listView.getItemAtPosition(i)).getGroupId(), ((GroupItem) listView.getItemAtPosition(i)).getGroupName());
                }else{
                    Transactor.fragmentMainGroup(getFragmentManager().beginTransaction(), ((GroupItem) listView.getItemAtPosition(i)).getGroupId(), ((GroupItem) listView.getItemAtPosition(i)).getGroupName());
                }
            }
        });
    }

    public void destCreateTask(){
        destCreateTask = true;
    }

    public void toCreateGroup(){
        Transactor.fragmentCreateGroup(getFragmentManager().beginTransaction());
    }
}
