package com.hazizz.droid.Fragments;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.hazizz.droid.Activities.MainActivity;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOgroup;
import com.hazizz.droid.Listviews.GroupList.CustomAdapter;
import com.hazizz.droid.Listviews.GroupList.GroupItem;
import com.hazizz.droid.Manager;
import com.hazizz.droid.Transactor;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.R;

import java.util.ArrayList;
import java.util.List;

public class ChooseGroupFragment extends Fragment{

    public List<Integer> groupIDs;
    public List<POJOgroup> groups;
    private List<GroupItem> listGroup;
    private View v;
    private CustomAdapter adapter;
    private TextView textView_noContent;
    private TextView textView_title;

    private boolean destTaskEditor;


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_group, container, false);
        ((MainActivity)getActivity()).onFragmentCreated();
        groups = new ArrayList<POJOgroup>();

        destTaskEditor = getArguments().getBoolean("destTaskEditor");

        createViewList();
        getGroups();
        textView_noContent = v.findViewById(R.id.textView_noContent);
        textView_title = v.findViewById(R.id.textView_title);
        return v;
    }

    public void getGroups() {
        Log.e("hey", "atleast here 2");
        CustomResponseHandler responseHandler = new CustomResponseHandler() {
            @Override
            public void onPOJOResponse(Object response) {
                ArrayList<POJOgroup> castedListFullOfPojos = (ArrayList<POJOgroup>)response;
                for(POJOgroup g : castedListFullOfPojos){
                    listGroup.add(new GroupItem(R.drawable.ic_launcher_background, g.getName(), g.getId()));
                }

                adapter.notifyDataSetChanged();
            }

            @Override
            public void onEmptyResponse() {
                textView_noContent.setVisibility(v.VISIBLE);
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
                if (Manager.DestManager.getDest() == Manager.DestManager.TOCREATETASK) {
                    Transactor.fragmentCreateTask(getFragmentManager().beginTransaction(), ((GroupItem) listView.getItemAtPosition(i)).getGroupId(), ((GroupItem) listView.getItemAtPosition(i)).getGroupName(), Manager.DestManager.TOMAIN);
                }else if(Manager.DestManager.getDest() == Manager.DestManager.TOCREATEANNOUNCEMENT) {
                    Transactor.fragmentCreateAnnouncement(getFragmentManager().beginTransaction(), ((GroupItem) listView.getItemAtPosition(i)).getGroupId(), ((GroupItem) listView.getItemAtPosition(i)).getGroupName(), Manager.DestManager.TOMAIN);
              /*  }else if(Manager.DestManager.getDest() == Manager.DestManager.TOATCHOOSER){
                    Transactor.fragmentATChooser(getFragmentManager().beginTransaction(), ((GroupItem) listView.getItemAtPosition(i)).getGroupId()); */

                }else{
                    Transactor.fragmentMainGroup(getFragmentManager().beginTransaction(), ((GroupItem) listView.getItemAtPosition(i)).getGroupId(), ((GroupItem) listView.getItemAtPosition(i)).getGroupName());
                //    Transactor.fragmentGroupTab(getFragmentManager().beginTransaction(), ((GroupItem) listView.getItemAtPosition(i)).getGroupId(), ((GroupItem) listView.getItemAtPosition(i)).getGroupName());

                }
            }
        });
    }

}
