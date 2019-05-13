package com.hazizz.droid.fragments.GroupTabs;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.FragmentManager;
import android.support.v4.widget.SwipeRefreshLayout;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.hazizz.droid.activities.BaseActivity;
import com.hazizz.droid.cache.CurrentGroup;

import com.hazizz.droid.communication.requests.GetSubjects;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoError;
import com.hazizz.droid.communication.responsePojos.PojoSubject;
import com.hazizz.droid.fragments.ParentFragment.TabFragment;
import com.hazizz.droid.listviews.SubjectList.CustomAdapter;
import com.hazizz.droid.listviews.SubjectList.SubjectItem;
import com.hazizz.droid.navigation.Transactor;
import com.hazizz.droid.communication.MiddleMan;
import com.hazizz.droid.R;

import java.util.ArrayList;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class SubjectsFragment extends TabFragment {

    private View v;
    private CustomAdapter adapter;
    private List<SubjectItem> listSubject;

    private TextView textView_noContent;
    private SwipeRefreshLayout sRefreshLayout;

    private int groupId;


    CurrentGroup currentGroup;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_subjects, container, false);




        Log.e("hey", "subject group fragment created");
        fragmentSetup(((BaseActivity)getActivity()));
        groupId = GroupTabFragment.groupId;

        textView_noContent = v.findViewById(R.id.textView_noContent);
        sRefreshLayout = v.findViewById(R.id.swipe_refresh_layout); sRefreshLayout.bringToFront();
        sRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                getSubjects();
            }});
        sRefreshLayout.setColorSchemeColors(getResources().getColor(R.color.colorPrimaryDarkBlue), getResources().getColor(R.color.colorPrimaryLightBlue), getResources().getColor(R.color.colorPrimaryDarkBlue));
     //   getSubjects();

        currentGroup = CurrentGroup.getInstance();
        createViewList();
        if(!isViewShown) {
            isViewShown = true;
            getSubjects();
        }

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
                Transactor.fragmentDialogManageSubject(getFragmentManager().beginTransaction(), groupId, adapter.getItem(i).getSubjectId(), adapter.getItem(i).getSubjectName());
            }
        });
    }

    public void getSubjects(){
        CustomResponseHandler responseHandler = new CustomResponseHandler() {
            @Override
            public void onPOJOResponse(Object response) {
                adapter.clear();
                ArrayList<PojoSubject> pojoList = (ArrayList< PojoSubject>) response;
                if(pojoList.isEmpty()){
                    textView_noContent.setVisibility(v.VISIBLE);
                }else {
                    textView_noContent.setVisibility(v.INVISIBLE);
                    for ( PojoSubject t : pojoList) {
                        listSubject.add(new SubjectItem(t.getName(), t.getId()));
                        adapter.notifyDataSetChanged();
                    }
                }
                sRefreshLayout.setRefreshing(false);
            }
            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                textView_noContent.setVisibility(v.VISIBLE);
                sRefreshLayout.setRefreshing(false);
            }
            @Override
            public void onErrorResponse(PojoError error) {
                sRefreshLayout.setRefreshing(false);
            }
            @Override
            public void onNoConnection() {
                textView_noContent.setText(R.string.info_noInternetAccess);
                textView_noContent.setVisibility(View.VISIBLE);
                sRefreshLayout.setRefreshing(false);
            }
        };
        MiddleMan.newRequest(new GetSubjects(getActivity(), responseHandler, groupId));
    }

    public void toCreateSubject(FragmentManager fm){
        Transactor.fragmentCreateSubject(fm.beginTransaction(), GroupTabFragment.groupId, GroupTabFragment.groupName);
    }

    /*
    @Override
    public void onTabSelected() {
        super.onTabSelected();
        getSubjects();
    }
    */


    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (getView() != null && !isViewShown) {
            isViewShown = true;
            // fetchdata() contains logic to show data when page is selected mostly asynctask to fill the data
            getSubjects();
        } else {
            isViewShown = false;
        }
    }
}