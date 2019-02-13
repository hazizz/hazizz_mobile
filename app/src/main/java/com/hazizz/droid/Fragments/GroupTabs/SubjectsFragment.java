package com.hazizz.droid.Fragments.GroupTabs;

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
import com.hazizz.droid.Communication.POJO.Response.POJOsubject;
import com.hazizz.droid.Communication.Requests.GetSubjects;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Listviews.SubjectList.CustomAdapter;
import com.hazizz.droid.Listviews.SubjectList.SubjectItem;
import com.hazizz.droid.Manager;
import com.hazizz.droid.Transactor;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.R;

import java.util.ArrayList;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class SubjectsFragment extends Fragment {

    private View v;
    private CustomAdapter adapter;
    private List<SubjectItem> listSubject;

    private TextView textView_noContent;
    private SwipeRefreshLayout sRefreshLayout;

    private int groupId;
    private String groupName;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_subjects, container, false);
        Log.e("hey", "subject group fragment created");
        ((MainActivity)getActivity()).onFragmentCreated();
        groupId = getArguments().getInt(Strings.Path.GROUPID.toString());

        textView_noContent = v.findViewById(R.id.textView_noContent);
        sRefreshLayout = v.findViewById(R.id.swipe_refresh_layout); sRefreshLayout.bringToFront();
        sRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                getSubjects();
            }});

        createViewList();
        getSubjects();

        return v;
    }
    void createViewList(){
        listSubject = new ArrayList<>();
        ListView listView = (ListView)v.findViewById(R.id.listView_subjects);
        adapter = new CustomAdapter(getActivity(), R.layout.subject_item, listSubject);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                /*groupName = ((SubjectItem)listView.getItemAtPosition(i)).getGroup().getName();
                Transactor.fragmentViewAnnouncement(getFragmentManager().beginTransaction(),
                        ((SubjectItem)listView.getItemAtPosition(i)).getGroup().getId(),
                        ((SubjectItem)listView.getItemAtPosition(i)).getAnnouncementId(),
                        ((SubjectItem)listView.getItemAtPosition(i)).getGroup().getName(), false);
                */
            }
        });
    }
    private void getSubjects(){
        CustomResponseHandler responseHandler = new CustomResponseHandler() {
            @Override
            public void onPOJOResponse(Object response) {
                adapter.clear();
                ArrayList<POJOsubject> pojoList = (ArrayList<POJOsubject>) response;
                if(pojoList.size() == 0){
                    textView_noContent.setVisibility(v.VISIBLE);
                }else {
                    textView_noContent.setVisibility(v.INVISIBLE);
                    for (POJOsubject t : pojoList) {
                        listSubject.add(new SubjectItem(t.getName(), t.getId()));
                        adapter.notifyDataSetChanged();
                    }
                }
                sRefreshLayout.setRefreshing(false);
            }
            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                Log.e("hey", "4");
                Log.e("hey", "got here onFailure");
                textView_noContent.setVisibility(v.VISIBLE);
                sRefreshLayout.setRefreshing(false);
            }
            @Override
            public void onErrorResponse(POJOerror error) {
                Log.e("hey", "onErrorResponse");
                sRefreshLayout.setRefreshing(false);
            }
            @Override
            public void onEmptyResponse() {
                sRefreshLayout.setRefreshing(false);
            }
            @Override
            public void onNoConnection() {
                textView_noContent.setText(R.string.info_noInternetAccess);
                textView_noContent.setVisibility(View.VISIBLE);
                sRefreshLayout.setRefreshing(false);
                //    textView_noContent.
            }
        };
        MiddleMan.newRequest(new GetSubjects(getActivity(), responseHandler, groupId));
    }

    public void toCreateSubject(FragmentManager fm){
        Manager.DestManager.setDest(Manager.DestManager.TOSUBJECTS);
        Transactor.fragmentCreateSubject(fm.beginTransaction(), Manager.GroupManager.getGroupId(), Manager.GroupManager.getGroupName());//GroupTabFragment.groupName);
    }

}