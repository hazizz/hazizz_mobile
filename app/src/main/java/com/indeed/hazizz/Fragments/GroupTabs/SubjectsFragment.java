package com.indeed.hazizz.Fragments.GroupTabs;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.widget.SwipeRefreshLayout;
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
import com.indeed.hazizz.Communication.POJO.Response.POJOsubject;
import com.indeed.hazizz.Listviews.SubjectList.CustomAdapter;
import com.indeed.hazizz.Listviews.SubjectList.SubjectItem;
import com.indeed.hazizz.Manager;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.util.ArrayList;
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
       // groupId = getArguments().getInt("groupId");

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
                /*groupName = ((SubjectItem)listView.getItemAtPosition(i)).getGroupData().getName();
                Transactor.fragmentViewAnnouncement(getFragmentManager().beginTransaction(),
                        ((SubjectItem)listView.getItemAtPosition(i)).getGroupData().getId(),
                        ((SubjectItem)listView.getItemAtPosition(i)).getAnnouncementId(),
                        ((SubjectItem)listView.getItemAtPosition(i)).getGroupData().getName(), false);
                */
            }
        });
    }
    private void getSubjects(){
        adapter.clear();
        CustomResponseHandler responseHandler = new CustomResponseHandler() {
            @Override
            public void onResponse(HashMap<String, Object> response) { }
            @Override
            public void onPOJOResponse(Object response) {
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
            public void onSuccessfulResponse() { }
            @Override
            public void onNoConnection() {
                textView_noContent.setText("Nincs internet kapcsolat");
                textView_noContent.setVisibility(View.VISIBLE);
                sRefreshLayout.setRefreshing(false);
                //    textView_noContent.
            }
        };
        HashMap<String, Object> vars = new HashMap<>();
        vars.put("groupId", Integer.toString(GroupTabFragment.groupId));
        MiddleMan.newRequest(this.getActivity(),"getSubjects", null, responseHandler, vars);
    }

    public void toCreateSubject(FragmentManager fm){
        Manager.DestManager.setDest(Manager.DestManager.TOSUBJECTS);
        Transactor.fragmentCreateSubject(fm.beginTransaction(), GroupTabFragment.groupId, GroupTabFragment.groupName);
    }

}