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
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgetTaskDetailed;
import com.indeed.hazizz.Communication.Strings;
import com.indeed.hazizz.Manager;
import com.indeed.hazizz.MeInfo;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.util.EnumMap;
import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class ViewAnnouncementFragment extends Fragment implements AdapterView.OnItemSelectedListener{


    private Button button_comments;
    private Button button_delete;
    private Button button_edit;

    private int groupId, subjectId, announcementId;
    private String groupName;
    private String title;
    private String descripiton;

    private TextView type;
    private TextView textView_title;
    private TextView textView_description;
    private TextView creatorName;
    private TextView group;

    private CustomResponseHandler rh;
    private CustomResponseHandler rh_delete = new CustomResponseHandler() {
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
        public void onSuccessfulResponse() {
            button_delete.setEnabled(false);
        }
    };

    private boolean goBackToMain;
    private int commentId;
    private boolean gotResponse = false;

    private View v;

    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_viewannouncement, container, false);
        Log.e("hey", "im here lol");
        ((MainActivity)getActivity()).onFragmentCreated();
        type = v.findViewById(R.id.textView_tasktype);
        textView_title = v.findViewById(R.id.textView_title);
        textView_description = v.findViewById(R.id.editText_description);
        creatorName = v.findViewById(R.id.textView_creator);
        group = v.findViewById(R.id.textView_group);

        button_delete = v.findViewById(R.id.button_delete);
        button_edit = v.findViewById(R.id.button_edit);
        button_edit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(gotResponse){
                    Transactor.fragmentEditAnnouncement(getFragmentManager().beginTransaction(), Manager.GroupManager.getGroupId(), announcementId,Manager.GroupManager.getGroupName(), title, descripiton, Manager.DestManager.TOGROUP);//commentId);
                }
            }});


        button_delete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(gotResponse){
                    //   Transactor.fragmentCommentSection(getFragmentManager().beginTransaction(), commentId);//commentId);
                    EnumMap<Strings.Path, Object> vars = new EnumMap<>(Strings.Path.class);
                    vars.put(Strings.Path.GROUPID, groupId);
                    vars.put(Strings.Path.ANNOUNCEMENTID, announcementId);
                    CustomResponseHandler rh = new CustomResponseHandler() {
                        @Override
                        public void onSuccessfulResponse() {
                            if(Manager.DestManager.getDest() == Manager.DestManager.TOGROUP) {
                                Transactor.fragmentGroupAnnouncement(getFragmentManager().beginTransaction(), Manager.GroupManager.getGroupId(), Manager.GroupManager.getGroupName());
                            } else{
                                Transactor.fragmentMainAnnouncement(getFragmentManager().beginTransaction());
                            }
                        }
                        @Override
                        public void onErrorResponse(POJOerror error) {
                            button_delete.setEnabled(true);
                        }
                    };
                    button_delete.setEnabled(false);
                    MiddleMan.newRequest(getActivity(),"deleteAnnouncement", null, rh, vars);
                }
            }
        });
        button_comments = v.findViewById(R.id.button_comments);
        button_comments.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Transactor.fragmentCommentSection(getFragmentManager().beginTransaction(), groupId, subjectId, 0, announcementId);
            }
        });
        Bundle bundle = this.getArguments();
        if (bundle != null) {
            announcementId =  bundle.getInt("announcementId");
            groupId = bundle.getInt("groupId");
            subjectId = bundle.getInt("subjectId");
            if(Manager.ProfilePicManager.getCurrentGroupId() != groupId || Manager.DestManager.getDest() == Manager.DestManager.TOMAIN){
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
                };
                EnumMap<Strings.Path, Object> vars = new EnumMap<>(Strings.Path.class);
                vars.put(Strings.Path.GROUPID, Integer.toString(groupId));
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

                POJODetailedAnnouncement pojoResponse = (POJODetailedAnnouncement)response;

                Manager.GroupManager.setGroupId(pojoResponse.getGroup().getId());
                Manager.GroupManager.setGroupName(pojoResponse.getGroup().getName());

                groupId = pojoResponse.getGroup().getId();
                announcementId = pojoResponse.getId();

           //     commentId = (int)pojoResponse.getSections().get(0).getId();
                Log.e("hey", "id1 is: " +commentId );
                gotResponse = true;
              //  type.setText(((POJOAnnouncement)response).getType());
                title = pojoResponse.getTitle();
                descripiton = pojoResponse.getDescription();
                textView_title.setText(title);
                textView_description.setText(descripiton);
                String creatorUsername = pojoResponse.getCreator().getUsername();
                creatorName.setText(creatorUsername);
                //  subject.setText(((POJOgetTaskDetailed)response).getSubject().getName());
                group.setText(pojoResponse.getGroup().getName());


                if(MeInfo.getProfileName().equals(creatorUsername)){
                    button_delete.setVisibility(View.VISIBLE);
                    button_edit.setVisibility(View.VISIBLE);
                }
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
                //    textView_noContent.setText(R.string.info_noInternetAccess);

            }
        };
        EnumMap<Strings.Path, Object> vars = new EnumMap<>(Strings.Path.class);
        vars.put(Strings.Path.GROUPID, Integer.toString(groupId));
        vars.put(Strings.Path.ANNOUNCEMENTID, Integer.toString(announcementId));
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

