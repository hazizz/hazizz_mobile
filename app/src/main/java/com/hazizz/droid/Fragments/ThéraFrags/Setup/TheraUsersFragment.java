package com.hazizz.droid.Fragments.ThéraFrags.Setup;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;

import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.Requests.RequestType.Thera.PojoSession;
import com.hazizz.droid.Communication.Requests.RequestType.Thera.ThRemoveSession;
import com.hazizz.droid.Communication.Requests.RequestType.Thera.ThReturnSessions.ThReturnSessions;
import com.hazizz.droid.Fragments.ParentFragment.ParentFragment;
import com.hazizz.droid.Listener.OnBackPressedListener;
import com.hazizz.droid.Listviews.TheraUserList.CustomAdapter;
import com.hazizz.droid.Listviews.TheraUserList.TheraUserItem;
import com.hazizz.droid.R;
import com.hazizz.droid.SharedPrefs;
import com.hazizz.droid.Transactor;

import java.util.ArrayList;
import java.util.List;

public class TheraUsersFragment  extends ParentFragment {

    private CustomAdapter adapter;
    private List<TheraUserItem> listUsers;
    private TheraUserItem selectedItem = null;

    private Button button_add;
    private Button button_login;
    private Button button_delete;

    private View view_lastItem = null;

    ListView listView;


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_th_users, container, false);
        Log.e("hey", "TheraUsersFragment fragment created");

        fragmentSetup(R.string.title_kreta_users);
        setOnBackPressedListener(new OnBackPressedListener() {
            @Override
            public void onBackPressed() {
                Transactor.fragmentThMain(getFragmentManager().beginTransaction());
            }
        });


        button_add = v.findViewById(R.id.button_add);
        button_add.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Transactor.fragmentThLogin(getFragmentManager().beginTransaction());
            }
        });
        button_login = v.findViewById(R.id.button_login);
        button_login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(selectedItem != null){
                    long sessionId = selectedItem.getId();
                    if(selectedItem.getStatus().equals("ACTIVE")) {
                        SharedPrefs.ThSessionManager.setSessionId(getContext(), sessionId);
                        SharedPrefs.ThLoginData.setData(getContext(), sessionId, selectedItem.getUsername(), selectedItem.getUrl());
                        Transactor.fragmentThMain(getFragmentManager().beginTransaction());
                    }
                    else{
                        Transactor.fragmentThLoginAuthSession(getFragmentManager().beginTransaction(), sessionId,
                                selectedItem.getUrl(),
                                selectedItem.getUsername());
                    }
                }
            }
        });
        button_delete = v.findViewById(R.id.button_delete);
        button_delete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(selectedItem != null){
                    MiddleMan.newThRequest(new ThRemoveSession(getActivity(), new CustomResponseHandler() {
                        @Override public void onSuccessfulResponse() {
                            adapter.remove(selectedItem);
                        }
                    },(int)selectedItem.getId()));
                }
            }
        });

        button_login.setVisibility(View.INVISIBLE);
        button_delete.setVisibility(View.INVISIBLE);


             //  ((MainActivity)getActivity()).setGroupName(groupName);
        createViewList();
        getUsers();

        return v;
    }
    void createViewList(){
        listUsers = new ArrayList<>();
        listView = (ListView)v.findViewById(R.id.listView_classes);
        adapter = new CustomAdapter(getActivity(), R.layout.th_users_item, listUsers);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                if(view_lastItem != null) {
                    view_lastItem.setBackgroundColor(getResources().getColor(R.color.white));
                }
                view.setBackgroundColor(getResources().getColor(R.color.colorPrimaryLightestBlue));
                view_lastItem = view;

                selectedItem = adapter.getItem(i);

                button_login.setVisibility(View.VISIBLE);
                button_delete.setVisibility(View.VISIBLE);
            }
        });


    }

    private void saveSession(TheraUserItem userItem){
        SharedPrefs.ThSessionManager.setSessionId(getContext(), (int) userItem.getId());
    }

    private void getUsers(){
        CustomResponseHandler responseHandler = new CustomResponseHandler() {
            @Override
            public void onPOJOResponse(Object response) {
                adapter.clear();
                ArrayList<PojoSession> pojoList = (ArrayList<PojoSession>) response;
                if(pojoList.isEmpty()){
                    Transactor.fragmentThLogin(getFragmentManager().beginTransaction());
                }else {
                    for (PojoSession t : pojoList) {
                        listUsers.add(new TheraUserItem(t.getId(), t.getStatus(), t.getUsername(), t.getUrl()));
                        adapter.notifyDataSetChanged();
                    }
                }
            }
            @Override
            public void onNoConnection() {
            }
        };
        MiddleMan.newThRequest(new ThReturnSessions(getActivity(),responseHandler));
    }
}
