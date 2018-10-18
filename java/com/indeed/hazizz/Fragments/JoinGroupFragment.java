package com.indeed.hazizz.Fragments;

import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;

import com.indeed.hazizz.Activities.MainActivity;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOauth;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.POJO.Response.POJOgroup;
import com.indeed.hazizz.Listviews.GroupList.CustomAdapter;
import com.indeed.hazizz.Listviews.GroupList.GroupItem;
import com.indeed.hazizz.R;
import com.indeed.hazizz.SharedPrefs;
import com.indeed.hazizz.Transactor;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class JoinGroupFragment extends Fragment {

    private View v;

    private EditText editText_joinGroup;
    private Button button_joinGroup;
    private TextView textView_error;

    private String groupName;
    private int groupId;

    CustomResponseHandler rh_joinGroup = new CustomResponseHandler() {
        @Override
        public void onResponse(HashMap<String, Object> response) {

        }

        @Override
        public void onPOJOResponse(Object response) {

        }

        @Override
        public void onFailure() {
            Log.e("hey", "4");
            Log.e("hey", "got here onFailure");
        }

        @Override
        public void onErrorResponse(POJOerror error) {
            Log.e("hey", "onErrorResponse");
        }

        @Override
        public void onEmptyResponse() {
          //  textView_noContent.setVisibility(v.VISIBLE);
        }

        @Override
        public void onSuccessfulResponse() {
            Transactor.fragmentMainGroup(getFragmentManager().beginTransaction(), groupId, groupName);
        }
    };

    CustomResponseHandler rh_getGroups = new CustomResponseHandler() {
        @Override
        public void onResponse(HashMap<String, Object> response) {

        }

        @Override
        public void onPOJOResponse(Object response) {
            boolean found = false;
            ArrayList<POJOgroup> castedList = (ArrayList<POJOgroup>) response;
            for(POJOgroup g : castedList){
                if(g.getName().equals(groupName)) {
                    if (g.getGroupType().equals("OPEN")) {
                        groupId = g.getId();
                        HashMap<String, Object> vars = new HashMap<>();
                        vars.put("groupId", groupId);
                        MiddleMan.newRequest(getActivity(), "joinGroup", null, rh_joinGroup, vars);
                        found = true;
                        break;
                    } else {
                        textView_error.setText("Nincs jogod belépni");
                        break;
                    }
                }
            }
            if(!found){
                textView_error.setText("Nem létezik ilyen csoport");
            }
        }
        @Override
        public void onFailure() {
            Log.e("hey", "4");
            Log.e("hey", "got here onFailure");
            button_joinGroup.setEnabled(true);
        }

        @Override
        public void onErrorResponse(POJOerror error) {
            Log.e("hey", "onErrorResponse");
            button_joinGroup.setEnabled(true);

        }

        @Override
        public void onEmptyResponse() {
            //  textView_noContent.setVisibility(v.VISIBLE);
        }

        @Override
        public void onSuccessfulResponse() {
        }
    };


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_joingroup, container, false);
        ((MainActivity)getActivity()).onFragmentCreated();

        textView_error = v.findViewById(R.id.textView_error);
        textView_error.setTextColor(Color.rgb(255, 0, 0));
        editText_joinGroup = v.findViewById(R.id.editText_joinGroup);
        button_joinGroup = v.findViewById(R.id.button_joinGroup);
        button_joinGroup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                groupName = editText_joinGroup.getText().toString();
                MiddleMan.newRequest(getActivity(), "getGroups", null, rh_getGroups, null);
                button_joinGroup.setEnabled(false);
            }
        });


        return v;
    }
}