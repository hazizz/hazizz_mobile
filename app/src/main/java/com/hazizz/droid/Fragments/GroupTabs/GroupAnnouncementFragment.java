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

import com.hazizz.droid.cache.CurrentGroup;
import com.hazizz.droid.Communication.requests.GetAnnouncementsFromGroup;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Communication.responsePojos.announcementPojos.PojoAnnouncement;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.Communication.responsePojos.PojoError;
import com.hazizz.droid.fragments.ParentFragment.TabFragment;
import com.hazizz.droid.listviews.AnnouncementList.AnnouncementItem;
import com.hazizz.droid.listviews.AnnouncementList.Group.CustomAdapter;
import com.hazizz.droid.navigation.Transactor;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.R;

import java.util.ArrayList;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class GroupAnnouncementFragment extends TabFragment {

    private CustomAdapter adapter;
    private List<AnnouncementItem> listAnnouncement;

    private TextView textView_noContent;
    private SwipeRefreshLayout sRefreshLayout;

    private int groupId;
    private String groupName;

    private CurrentGroup currentGroup;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_announcements, container, false);
        Log.e("hey", "announcement group fragment created");





        fragmentSetup();
        groupId = GroupTabFragment.groupId;
        groupName = GroupTabFragment.groupName;



        textView_noContent = v.findViewById(R.id.textView_noContent);
        sRefreshLayout = v.findViewById(R.id.swipe_refresh_layout); sRefreshLayout.bringToFront();
        sRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                getAnnouncements();
            }});
        sRefreshLayout.setColorSchemeColors(getResources().getColor(R.color.colorPrimaryDarkBlue), getResources().getColor(R.color.colorPrimaryLightBlue), getResources().getColor(R.color.colorPrimaryDarkBlue));

        currentGroup = CurrentGroup.getInstance();
        createViewList();
        if(!isViewShown) {
            getAnnouncements();
            isViewShown = true;
        }

        return v;
    }
    void createViewList(){
        listAnnouncement = new ArrayList<>();
        ListView listView = (ListView)v.findViewById(R.id.listView_announcementGroup);
        adapter = new CustomAdapter(getActivity(), R.layout.announcement_item, listAnnouncement);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                groupName = ((AnnouncementItem)listView.getItemAtPosition(i)).getGroup().getName();
                    Transactor.fragmentViewAnnouncement(getFragmentManager().beginTransaction(),
                        ((AnnouncementItem)listView.getItemAtPosition(i)).getAnnouncementId(),
                            false, Strings.Dest.TOGROUP);
            }
        });
    }
    private void getAnnouncements(){
        CustomResponseHandler responseHandler = new CustomResponseHandler() {
            @Override
            public void onPOJOResponse(Object response) {
                adapter.clear();
                ArrayList<PojoAnnouncement> pojoList = (ArrayList<PojoAnnouncement>) response;
                if(pojoList.isEmpty()){
                    textView_noContent.setVisibility(v.VISIBLE);
                }else {
                    textView_noContent.setVisibility(v.INVISIBLE);
                    for (PojoAnnouncement t : pojoList) {
                        listAnnouncement.add(new AnnouncementItem(t.getTitle(),
                                t.getDescription(), t.getGroup(), t.getCreator(), t.getSubject(), t.getId()));
                        adapter.notifyDataSetChanged();
                        Log.e("hey", t.getId() + " " + t.getGroup().getId());
                    }
                }
                sRefreshLayout.setRefreshing(false);
            }
            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                textView_noContent.setVisibility(v.VISIBLE);
                sRefreshLayout.setRefreshing(false);
            }
            @Override public void onErrorResponse(PojoError error) { sRefreshLayout.setRefreshing(false); }
            @Override
            public void onNoConnection() {
                textView_noContent.setText(R.string.info_noInternetAccess);
                textView_noContent.setVisibility(View.VISIBLE);
                sRefreshLayout.setRefreshing(false);
            }
        };
        MiddleMan.newRequest(new GetAnnouncementsFromGroup(getActivity(),responseHandler, (int)currentGroup.getGroupId()));
    }

    public void toAnnouncementEditor(FragmentManager fm){
        Transactor.fragmentCreateAnnouncement(fm.beginTransaction(),(int)currentGroup.getGroupId(), GroupTabFragment.groupName, Strings.Dest.TOGROUP);
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (getView() != null && !isViewShown) {
            isViewShown = true;
            getAnnouncements();
        } else {
            isViewShown = false;
        }
    }


}


