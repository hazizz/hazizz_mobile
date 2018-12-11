package com.indeed.hazizz.Fragments;


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
import android.widget.TextView;

import com.indeed.hazizz.Activities.MainActivity;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.AnnouncementPOJOs.POJODetailedAnnouncement;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOMembersProfilePic;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Manager;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class ViewAnnouncementFragment extends Fragment implements AdapterView.OnItemSelectedListener{

    private Button button_comments;

    private int groupId;
    private int announcementId;
    private String groupName;

    private TextView type;
    private TextView title;
    private TextView description;
    private TextView creatorName;
    private TextView group;

    private CustomResponseHandler rh;


    private boolean goBackToMain;
    private int commentId;
    private boolean gotResponse = false;

    private View v;

    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_viewannouncement, container, false);
        Log.e("hey", "im here lol");
        ((MainActivity)getActivity()).onFragmentCreated();
        type = v.findViewById(R.id.textView_tasktype);
        title = v.findViewById(R.id.textView_title);
        description = v.findViewById(R.id.editText_description);
        creatorName = v.findViewById(R.id.textView_creator);
        group = v.findViewById(R.id.textView_group);

        button_comments = v.findViewById(R.id.button_comments);
        button_comments.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(gotResponse){
                    Transactor.fragmentCommentSection(getFragmentManager().beginTransaction(), commentId);//commentId);
                }
            }
        });

        Bundle bundle = this.getArguments();
        if (bundle != null) {
            announcementId =  bundle.getInt("announcementId");
            groupId = bundle.getInt("groupId");
            if(Manager.ProfilePicManager.getCurrentGroupId() != groupId){
                CustomResponseHandler responseHandler = new CustomResponseHandler() {
                    @Override
                    public void onResponse(HashMap<String, Object> response) { }
                    @Override
                    public void onPOJOResponse(Object response) {
                        Manager.ProfilePicManager.setCurrentGroupMembersProfilePic((HashMap<Integer, POJOMembersProfilePic>)response, groupId);
                    }
                    @Override
                    public void onFailure(Call<ResponseBody> call, Throwable t) {
                        Log.e("hey", "4");
                        Log.e("hey", "got here onFailure");
                    }
                    @Override
                    public void onErrorResponse(POJOerror error) {
                        Log.e("hey", "onErrorResponse");
                    }
                    @Override
                    public void onEmptyResponse() { }
                    @Override
                    public void onSuccessfulResponse() { }
                    @Override
                    public void onNoConnection() { }
                };
                HashMap<String, Object> vars = new HashMap<>();
                vars.put("groupId", Integer.toString(groupId));
                MiddleMan.newRequest(this.getActivity(),"getGroupMembersProfilePic", null, responseHandler, vars);
            }
            groupName = bundle.getString("groupName");
            goBackToMain = bundle.getBoolean("goBackToMain");

            Log.e("hey", "got IDs");
            Log.e("hey", announcementId + ", " + groupId);
        }else{Log.e("hey", "bundle is null");}
        rh = new CustomResponseHandler() {
            @Override
            public void onResponse(HashMap<String, Object> response) {
                Log.e("hey", "got regular response");

            }
            @Override
            public void onPOJOResponse(Object response) {
                commentId = (int)((POJODetailedAnnouncement)response).getSections().get(0).getId();
                Log.e("hey", "id1 is: " +commentId );
                gotResponse = true;
              //  type.setText(((POJOAnnouncement)response).getType());
                title.setText("Cím: " + ((POJODetailedAnnouncement)response).getTitle());
                description.setText(((POJODetailedAnnouncement)response).getDescription());
                creatorName.setText(((POJODetailedAnnouncement)response).getCreator().getUsername());
                //  subject.setText(((POJOgetTaskDetailed)response).getSubjectData().getName());
                group.setText(((POJODetailedAnnouncement)response).getGroup().getName());
            }
            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                Log.e("hey", "4");
                Log.e("hey", "got here onFailure");
                Log.e("hey", "task created");
            }
            @Override
            public void onErrorResponse(POJOerror error) {
                Log.e("hey", "onErrorResponse");
            }
            @Override
            public void onEmptyResponse() { }
            @Override
            public void onSuccessfulResponse() { }
            @Override
            public void onNoConnection() {
                //    textView_noContent.setText("Nincs internet kapcsolat");

            }
        };
        HashMap<String, Object> vars = new HashMap<>();
        vars.put("groupId", Integer.toString(groupId));
        vars.put("announcementId", Integer.toString(announcementId));
        MiddleMan.newRequest(this.getActivity(), "getAnnouncement", null, rh, vars);

        return v;
    }

    @Override
    public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
    }
    @Override
    public void onNothingSelected(AdapterView<?> adapterView) {
    }

    public int getGroupId(){
        return groupId;
    }
    public String getGroupName(){
        return groupName;
    }
    public boolean getGoBackToMain(){
        return goBackToMain;
    }


}

