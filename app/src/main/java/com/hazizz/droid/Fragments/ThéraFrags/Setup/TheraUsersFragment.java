package com.hazizz.droid.Fragments.ThéraFrags.Setup;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.widget.SwipeRefreshLayout;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.Requests.RequestType.Thera.ThCreateSession.PojoSession;
import com.hazizz.droid.Communication.Requests.RequestType.Thera.ThReturnSessions.ThReturnSessions;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Fragments.ParentFragment.ParentFragment;
import com.hazizz.droid.Listviews.AnnouncementList.AnnouncementItem;
import com.hazizz.droid.Listviews.TheraUserList.CustomAdapter;
import com.hazizz.droid.Listviews.TheraUserList.TheraUserItem;
import com.hazizz.droid.R;
import com.hazizz.droid.Transactor;

import java.util.ArrayList;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class TheraUsersFragment  extends ParentFragment {

    private CustomAdapter adapter;
    private List<TheraUserItem> listUsers;

    private TextView textView_noContent;
    private SwipeRefreshLayout sRefreshLayout;


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_th_users, container, false);
        Log.e("hey", "TheraUsersFragment fragment created");

        fragmentSetup(R.string.title_thera_users);


        textView_noContent = v.findViewById(R.id.textView_noContent);
             //  ((MainActivity)getActivity()).setGroupName(groupName);
        createViewList();
        getUsers();

        return v;
    }
    void createViewList(){
        listUsers = new ArrayList<>();
        ListView listView = (ListView)v.findViewById(R.id.listView_announcementGroup);
        adapter = new CustomAdapter(getActivity(), R.layout.announcement_main_item, listUsers);
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
    private void getUsers(){

        CustomResponseHandler responseHandler = new CustomResponseHandler() {

            @Override
            public void onPOJOResponse(Object response) {
                adapter.clear();
                ArrayList<PojoSession> pojoList = (ArrayList<PojoSession>) response;
                if(pojoList.isEmpty()){
                    textView_noContent.setVisibility(v.VISIBLE);
                }else {
                    textView_noContent.setVisibility(v.INVISIBLE);
                    for (PojoSession t : pojoList) {
                        listUsers.add(new TheraUserItem(t.getId(), t.getStatus(), t.getUrl()));
                        adapter.notifyDataSetChanged();
                    }
                }
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
            public void onEmptyResponse() {
                sRefreshLayout.setRefreshing(false);
            }
            @Override
            public void onNoConnection() {
                textView_noContent.setText(R.string.info_noInternetAccess);
                textView_noContent.setVisibility(View.VISIBLE);
                sRefreshLayout.setRefreshing(false);
            }
        };
        MiddleMan.newRequest(new ThReturnSessions(getActivity(),responseHandler));
    }
}
