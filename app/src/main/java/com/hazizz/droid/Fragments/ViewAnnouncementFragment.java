package com.hazizz.droid.Fragments;


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

import com.crashlytics.android.answers.Answers;
import com.crashlytics.android.answers.CustomEvent;
import com.hazizz.droid.Activities.MainActivity;
import com.hazizz.droid.Communication.POJO.Response.AnnouncementPOJOs.POJODetailedAnnouncement;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOMembersProfilePic;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Manager;
import com.hazizz.droid.Transactor;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.R;

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
                    Transactor.fragmentEditAnnouncement(getFragmentManager().beginTransaction(), Manager.GroupManager.getGroupId(), announcementId, Manager.GroupManager.getGroupName(), title, descripiton, Manager.DestManager.TOGROUP);//commentId);
                }
            }});


        button_delete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(gotResponse){
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
                            Answers.getInstance().logCustom(new CustomEvent("delete announcement")
                                    .putCustomAttribute("status", "success")
                            );
                        }
                        @Override
                        public void onErrorResponse(POJOerror error) {
                            button_delete.setEnabled(true);
                            Answers.getInstance().logCustom(new CustomEvent("delete announcement")
                                    .putCustomAttribute("status", error.getErrorCode())
                            );
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
                    public void onPOJOResponse(Object response) {
                        Manager.ProfilePicManager.setCurrentGroupMembersProfilePic((HashMap<Integer, POJOMembersProfilePic>)response, groupId);
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
            public void onPOJOResponse(Object response) {

                POJODetailedAnnouncement pojoResponse = (POJODetailedAnnouncement)response;

                Manager.GroupManager.setGroupId(pojoResponse.getGroup().getId());
                Manager.GroupManager.setGroupName(pojoResponse.getGroup().getName());

                groupId = pojoResponse.getGroup().getId();
                announcementId = pojoResponse.getId();

                gotResponse = true;
                title = pojoResponse.getTitle();
                descripiton = pojoResponse.getDescription();
                textView_title.setText(title);
                textView_description.setText(descripiton);
                String creatorUsername = pojoResponse.getCreator().getUsername();
                creatorName.setText(creatorUsername);
                group.setText(pojoResponse.getGroup().getName());


                if(Manager.MeInfo.getProfileName().equals(creatorUsername) || Manager.MeInfo.getRankInCurrentGroup().getValue() >= Strings.Rank.MODERATOR.getValue() ){
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

