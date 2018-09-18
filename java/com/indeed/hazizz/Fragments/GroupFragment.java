package com.indeed.hazizz.Fragments;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;

import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOgroup;
import com.indeed.hazizz.R;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class GroupFragment extends Fragment {

    public List<Integer> groupIDs;
    public List<POJOgroup> groups;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_group, container, false);

       // ListView mListView = (ListView) getView().findViewById(R.id.listView);

        ListView name = (ListView) v.findViewById(R.id.listView);

        /*
        Group group1 = new Group("groupName");

        ArrayList<Group> groupList = new ArrayList<>();
        groupList.add(group1);

        GroupListAdapter adapter = new GroupListAdapter(this, R.layout.adapter_view_layout, groupList);
        */
        Log.e("hey", "im here lol");

     //   groupIDs = new ArrayList<Integer>();
        groups = new ArrayList<POJOgroup>();

        groupIDs = getArguments().getIntegerArrayList("groupIDs");

        groups = getGroups(groupIDs);

       // return super.onCreateView(inflater, container, savedInstanceState);
        return inflater.inflate(R.layout.fragment_group, container, false);

    }

    public List<POJOgroup> getGroups(List<Integer> gIDs){
        List<POJOgroup> groupsList = new ArrayList<POJOgroup>();
        Log.e("hey", "atleast here 2");
        CustomResponseHandler responseHandler = new CustomResponseHandler() {
            @Override
            public void onResponse(HashMap<String, Object> response) {

            }

            @Override
            public void onResponse1(Object response) {
                groupsList.add((POJOgroup) response);
                Log.e("hey", "getGroups works");
            }

            @Override
            public void onFailure() {
                Log.e("hey", "4");
                Log.e("hey", "got here onFailure");
            }

            @Override
            public void onErrorResponse(HashMap<String, Object> errorResponse) {
                Log.e("hey", "onErrorResponse");
            }
        };
        if(groupIDs == null){
            Log.e("hey", "group id is null 1");

        }
        for(int groupID : gIDs) {
            Log.e("hey", "here 1");
            MiddleMan sendRegisterRequest = new MiddleMan(this.getActivity(), "getGroup", null, responseHandler, groupID);
            sendRegisterRequest.sendRequest2();
        }
       /* Context context = getActivity();
        SharedPreferences sharedPref = getActivity().getSharedPreferences(
                getString(R.string.preference_file_key), Context.MODE_PRIVATE);); */
        return groupsList;
    }


}
