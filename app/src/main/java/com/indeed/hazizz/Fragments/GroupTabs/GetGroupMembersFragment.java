package com.indeed.hazizz.Fragments.GroupTabs;

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

import com.indeed.hazizz.Activities.MainActivity;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOMembersProfilePic;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.POJO.Response.POJOuser;
import com.indeed.hazizz.Communication.Strings;
import com.indeed.hazizz.Listviews.UserList.CustomAdapter;
import com.indeed.hazizz.Listviews.UserList.UserItem;

import com.indeed.hazizz.Manager;
import com.indeed.hazizz.R;

import java.util.ArrayList;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class GetGroupMembersFragment extends Fragment {

    private List<UserItem> listUser;
    private View v;
    private CustomAdapter adapter;
    private int groupId;
    private List<POJOMembersProfilePic> userProfilePics = new ArrayList<POJOMembersProfilePic>();

    private TextView textView_noContent;
    private SwipeRefreshLayout sRefreshLayout;


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_getgroupmembers, container, false);
        ((MainActivity)getActivity()).onFragmentCreated();

        groupId = getArguments().getInt("groupId");
        textView_noContent = v.findViewById(R.id.textView_noContent);

        sRefreshLayout = v.findViewById(R.id.swipe_refresh_layout);
        sRefreshLayout.bringToFront();
        sRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                getUser();
            }});

        createViewList();
        getUser();

        return v;
    }

    public void getUser() {
        adapter.clear();
        CustomResponseHandler responseHandler = new CustomResponseHandler() {
            @Override
            public void onResponse(HashMap<String, Object> response) { }
            @Override
            public void onPOJOResponse(Object response) {
                textView_noContent.setVisibility(v.INVISIBLE);
                ArrayList<POJOuser> castedListFullOfPojos = (ArrayList<POJOuser>)response;
                HashMap<Integer, POJOMembersProfilePic> profilePicMap = Manager.ProfilePicManager.getCurrentGroupMembersProfilePic();
                if(castedListFullOfPojos != null && castedListFullOfPojos.size() != 0) {
                    for (POJOuser u : castedListFullOfPojos) {
                        try {
                            Log.e("hey", "GETDATA, userId: " + u.getId() + ", data is: " + profilePicMap.get(u.getId()).getData());
                            listUser.add(new UserItem(u.getUsername(), profilePicMap.get(u.getId()).getData()));
                        } catch (NullPointerException e) {
                            listUser.add(new UserItem(u.getUsername(), null));
                        }
                    }
                }else{
                    textView_noContent.setVisibility(View.VISIBLE);
                }
                adapter.notifyDataSetChanged();
                sRefreshLayout.setRefreshing(false);
                Log.e("hey", "got response");
            }
            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                Log.e("hey", "4");
                Log.e("hey", "got here onFailure");
            }

            @Override
            public void onErrorResponse(POJOerror error) {
                Log.e("hey", "onErrorResponse");
                sRefreshLayout.setRefreshing(false);
            }
            @Override
            public void onEmptyResponse(){sRefreshLayout.setRefreshing(false);}
            @Override
            public void onSuccessfulResponse(){}
            @Override
            public void onNoConnection(){
                textView_noContent.setText(R.string.info_noInternetAccess);
                textView_noContent.setVisibility(View.VISIBLE);
                sRefreshLayout.setRefreshing(false);
            }
        };
        EnumMap<Strings.Path, Object> vars = new EnumMap<>(Strings.Path.class);
        vars.put(Strings.Path.GROUPID, Integer.toString(groupId));
        MiddleMan.newRequest(this.getActivity(),"getGroupMembers", null, responseHandler, vars);
    }

    void createViewList(){
        listUser = new ArrayList<>();

        ListView listView = (ListView)v.findViewById(R.id.listView_getGroupMembers);

        adapter = new CustomAdapter(getActivity(), R.layout.user_item, listUser);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {

            }
        });
    }
}
