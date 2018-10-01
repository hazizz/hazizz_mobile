package com.indeed.hazizz.Fragments;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;

import com.indeed.hazizz.Activities.MainActivity;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOgroup;
import com.indeed.hazizz.Communication.Requests.Request;
import com.indeed.hazizz.Listviews.GroupList.CustomAdapter;
import com.indeed.hazizz.Listviews.GroupList.GroupItem;
import com.indeed.hazizz.R;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class GroupFragment extends Fragment {

    public List<Integer> groupIDs;
    public List<POJOgroup> groups;
    private List<GroupItem> listGroup;
    private View v;
    private CustomAdapter adapter;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_group, container, false);
        Log.e("hey", "im here lol");

        groups = new ArrayList<POJOgroup>();
        groupIDs = getArguments().getIntegerArrayList("groupIDs");
       // groups = getGroups(groupIDs);
        createViewList();
        getGroups(groupIDs);

        return v;
    }

    public void getGroups(List<Integer> gIDs) {
        List<POJOgroup> groupsList = new ArrayList<POJOgroup>();
        Log.e("hey", "atleast here 2");
        CustomResponseHandler responseHandler = new CustomResponseHandler() {
            @Override
            public void onResponse(HashMap<String, Object> response) {

            }

            @Override
            public void onPOJOResponse(Object response) {
                groupsList.add((POJOgroup) response);
                listGroup.add(new GroupItem(R.drawable.ic_launcher_background, ((POJOgroup) response).getName()));
                adapter.notifyDataSetChanged();
                Log.e("hey", "got response");
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
        int size = gIDs.size() - 1;
        for (int i = 0; i <= size; i++) {
            Log.e("hey", "here 1");
            HashMap<String, Object> vars = new HashMap<>();
            vars.put("id", gIDs.get(i));
            MiddleMan.newRequest(this.getActivity(), "getGroup", null, responseHandler, vars);
        }
    }

    void createViewList(){
        listGroup = new ArrayList<>();

        ListView listView = (ListView)v.findViewById(R.id.listView1);

        adapter = new CustomAdapter(getActivity(), R.layout.list_item, listGroup);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                makeTransaction(new CreateTaskFragment());
            }
        });
    }

    void makeTransaction(Fragment frag){
        FragmentTransaction fragmentTransaction = getFragmentManager().beginTransaction();
        fragmentTransaction.add(R.id.fragment_container, frag);
        fragmentTransaction.commit();
    }
}
