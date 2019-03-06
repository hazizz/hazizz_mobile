package com.hazizz.droid.Fragments.MainTab;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.hazizz.droid.Activities.MainActivity;
import com.hazizz.droid.Communication.POJO.Response.AnnouncementPOJOs.POJOAnnouncement;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.Requests.GetMyAnnouncements;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Listviews.AnnouncementList.AnnouncementItem;
import com.hazizz.droid.Listviews.AnnouncementList.Main.CustomAdapter;
import com.hazizz.droid.Transactor;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.R;

import java.util.ArrayList;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class MainAnnouncementFragment extends Fragment{

    private View v;
    private CustomAdapter adapter;
    private List<AnnouncementItem> listTask;

    private TextView textView_noContent;
    private SwipeRefreshLayout sRefreshLayout;


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_announcements, container, false);
        Log.e("hey", "mainGroup fragment created");
        ((MainActivity)getActivity()).onFragmentCreated();

        textView_noContent = v.findViewById(R.id.textView_noContent);
        sRefreshLayout = (SwipeRefreshLayout) v.findViewById(R.id.swipe_refresh_layout); sRefreshLayout.bringToFront();
        sRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                getAnnouncements();
            }});sRefreshLayout.setColorSchemeColors(getResources().getColor(R.color.colorPrimaryDarkBlue), getResources().getColor(R.color.colorPrimaryLightBlue), getResources().getColor(R.color.colorPrimaryDarkBlue));
        //  ((MainActivity)getActivity()).setGroupName(groupName);
        createViewList();
        getAnnouncements();

        return v;
    }
    void createViewList(){
        listTask = new ArrayList<>();
        ListView listView = (ListView)v.findViewById(R.id.listView_announcementGroup);
        adapter = new CustomAdapter(getActivity(), R.layout.announcement_main_item, listTask);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
               // groupName = ((AnnouncementItem)listView.getItemAtPosition(i)).getGroup().getName();
                Transactor.fragmentViewAnnouncement(getFragmentManager().beginTransaction(),
                        ((AnnouncementItem)listView.getItemAtPosition(i)).getAnnouncementId(),
                        false, Strings.Dest.TOMAIN);

            }
        });
    }
    private void getAnnouncements(){

        CustomResponseHandler responseHandler = new CustomResponseHandler() {

            @Override
            public void onPOJOResponse(Object response) {
                adapter.clear();
                ArrayList<POJOAnnouncement> pojoList = (ArrayList<POJOAnnouncement>) response;
                if(pojoList.size() == 0){
                    textView_noContent.setVisibility(v.VISIBLE);
                }else {
                    textView_noContent.setVisibility(v.INVISIBLE);
                    for (POJOAnnouncement t : pojoList) {
                        listTask.add(new AnnouncementItem(t.getTitle(),
                                t.getDescription(), t.getGroup(), t.getCreator(),
                                t.getSubject(), t.getId()));
                        adapter.notifyDataSetChanged();
                        Log.e("hey", t.getId() + " " + t.getGroup().getId());
                    }
                    Log.e("hey", "got response");
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
        //  MiddleMan.request.getTasksFromGroup(this.getActivity(), null, responseHandler, vars);
        MiddleMan.newRequest(new GetMyAnnouncements(getActivity(),responseHandler));
    }
}
