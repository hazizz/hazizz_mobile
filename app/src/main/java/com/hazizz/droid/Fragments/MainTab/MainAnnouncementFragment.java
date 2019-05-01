package com.hazizz.droid.fragments.MainTab;

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

import com.hazizz.droid.activities.MainActivity;
import com.hazizz.droid.cache.HCache;
import com.hazizz.droid.Communication.requests.GetAnnouncementsFromMe;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Communication.responsePojos.announcementPojos.PojoAnnouncement;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.Communication.responsePojos.PojoError;
import com.hazizz.droid.listviews.AnnouncementList.AnnouncementItem;
import com.hazizz.droid.listviews.AnnouncementList.Main.CustomAdapter;
import com.hazizz.droid.navigation.Transactor;
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

        processData(HCache.getInstance()
                .getAnnouncementsFromMe(getContext()));

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

    private void processData(List<PojoAnnouncement> data){
        if(data != null){
            adapter.clear();
            if(data.isEmpty()){
                textView_noContent.setVisibility(v.VISIBLE);
            }else {
                textView_noContent.setVisibility(v.INVISIBLE);
                for (PojoAnnouncement t : data) {
                    listTask.add(new AnnouncementItem(t.getTitle(),
                            t.getDescription(), t.getGroup(), t.getCreator(),
                            t.getSubject(), t.getId()));
                    adapter.notifyDataSetChanged();
                }
            }
            sRefreshLayout.setRefreshing(false);
        }
    }

    private void getAnnouncements(){
        CustomResponseHandler responseHandler = new CustomResponseHandler() {
            @Override public void getRawResponseBody(String rawResponseBody) {
                HCache.getInstance().setAnnouncementsFromMe(getContext(), rawResponseBody);
            }

            @Override
            public void onPOJOResponse(Object response) {
                ArrayList<PojoAnnouncement> data = (ArrayList<PojoAnnouncement>) response;
                processData(data);

            }
            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
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
        MiddleMan.newRequest(new GetAnnouncementsFromMe(getActivity(),responseHandler));
    }
}
