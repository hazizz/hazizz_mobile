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
import com.hazizz.droid.Communication.POJO.Response.GetUserPermissionInGroup;
import com.hazizz.droid.Communication.POJO.Response.POJOMembersProfilePic;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.POJO.Response.POJOuser;
import com.hazizz.droid.Communication.POJO.Response.PojoPermisionUsers;
import com.hazizz.droid.Communication.Requests.DeleteAT;
import com.hazizz.droid.Communication.Requests.GetAT;
import com.hazizz.droid.Communication.Requests.GetGroupMemberPermisions;
import com.hazizz.droid.Communication.Requests.GetGroupMembersProfilePic;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Manager;
import com.hazizz.droid.Transactor;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.R;

import java.util.HashMap;

public class ViewAnnouncementFragment extends Fragment implements AdapterView.OnItemSelectedListener{


    private Button button_comments;
    private Button button_delete;
    private Button button_edit;

    private short enable_button_comment = 0;
    private int groupId, announcementId, creatorId;
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
        public void onSuccessfulResponse() {
            button_delete.setEnabled(false);
        }
    };

    CustomResponseHandler permissionRh = new CustomResponseHandler() {
        @Override
        public void onPOJOResponse(Object response) {
            String rank = ((String)response);
            Log.e("hey", "talicska: " + rank);
            Strings.Rank r = Strings.Rank.NULL;
            if(Strings.Rank.USER.toString().equals(rank)){
                r = Strings.Rank.USER;
            }else if(Strings.Rank.MODERATOR.toString().equals(rank)){
                r = Strings.Rank.MODERATOR;
            }else if(Strings.Rank.OWNER.toString().equals(rank)) {
                r = Strings.Rank.OWNER;
            }
            Manager.MeInfo.setRankInCurrentGroup(r);

            Log.e("hey", "talicska 2: " + Manager.MeInfo.getRankInCurrentGroup().getValue() + " " + Manager.MeInfo.getRankInCurrentGroup().toString());

            if(Manager.MeInfo.getId() == creatorId || Manager.MeInfo.getRankInCurrentGroup().getValue() >= Strings.Rank.MODERATOR.getValue() ){
                button_delete.setVisibility(View.VISIBLE);
                button_edit.setVisibility(View.VISIBLE);
            }
        }
    };

    private boolean goBackToMain;
    private boolean gotResponse = false;

    private View v;

    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_viewannouncement, container, false);
        Log.e("hey", "im here lol");
        ((MainActivity)getActivity()).onFragmentCreated();

        getActivity().setTitle(R.string.title_fragment_view_announcement);

        type = v.findViewById(R.id.textView_tasktype);
        textView_title = v.findViewById(R.id.textView_subject);
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
                    MiddleMan.newRequest(new DeleteAT(getActivity(), rh, Strings.Path.ANNOUNCEMENTS, announcementId));
                }
            }
        });
        button_comments = v.findViewById(R.id.button_comments);
        button_comments.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Transactor.fragmentCommentSection(getFragmentManager().beginTransaction(), Strings.Path.ANNOUNCEMENTS.toString(), announcementId);
            }
        });
        Bundle bundle = this.getArguments();
        if (bundle != null) {
            announcementId =  bundle.getInt(Strings.Path.ANNOUNCEMENTID.toString());
            groupId = bundle.getInt(Strings.Path.GROUPID.toString());


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

                CustomResponseHandler r2 = new CustomResponseHandler() {
                    @Override
                    public void onPOJOResponse(Object response) {
                        PojoPermisionUsers pojoPermisionUser = (PojoPermisionUsers)response;
                        if(pojoPermisionUser != null) {
                            if(pojoPermisionUser.getOWNER() != null) {
                                for (POJOuser u : pojoPermisionUser.getOWNER()) {
                                    Manager.GroupRankManager.setRank(u.getId(), Strings.Rank.OWNER);
                                }
                            }if(pojoPermisionUser.getMODERATOR() != null) {
                                for (POJOuser u : pojoPermisionUser.getMODERATOR()) {
                                    Log.e("hey", "555: MODI");
                                    Manager.GroupRankManager.setRank(u.getId(), Strings.Rank.MODERATOR);
                                }
                            }if(pojoPermisionUser.getUSER() != null) {
                                for (POJOuser u : pojoPermisionUser.getUSER()) {
                                    Log.e("hey", "555: USER");
                                    Manager.GroupRankManager.setRank(u.getId(), Strings.Rank.USER);
                                }
                            }
                        }
                        enable_button_comment++;
                        visibleIfEnabled_button_comment();
                    }
                };
                MiddleMan.newRequest(new GetGroupMemberPermisions(getActivity(), r2, groupId));


                creatorId = (int)pojoResponse.getCreator().getId();

                MiddleMan.newRequest(new GetUserPermissionInGroup(getActivity(), permissionRh, groupId, (int)Manager.MeInfo.getId()));



                if(Manager.ProfilePicManager.getCurrentGroupId() != groupId || Manager.DestManager.getDest() == Manager.DestManager.TOMAIN){
                    CustomResponseHandler responseHandler = new CustomResponseHandler() {
                        @Override
                        public void onPOJOResponse(Object response) {
                            Manager.ProfilePicManager.setCurrentGroupMembersProfilePic((HashMap<Integer, POJOMembersProfilePic>)response, groupId);
                            enable_button_comment++;
                            visibleIfEnabled_button_comment();
                        }
                    };
                    MiddleMan.newRequest(new GetGroupMembersProfilePic(getActivity(),responseHandler, groupId));
                }else{
                    enable_button_comment++;
                    visibleIfEnabled_button_comment();
                }

                announcementId = pojoResponse.getId();

                gotResponse = true;
                title = pojoResponse.getTitle();
                descripiton = pojoResponse.getDescription();
                textView_title.setText(title);
                textView_description.setText(descripiton);
                creatorName.setText(pojoResponse.getCreator().getDisplayName());
                group.setText(pojoResponse.getGroup().getName());

            }
        };
        MiddleMan.newRequest(new GetAT(getActivity(),rh, Strings.Path.ANNOUNCEMENTS, announcementId));

        return v;
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        Manager.GroupManager.leftGroup();
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

    public void visibleIfEnabled_button_comment(){
        if(enable_button_comment > 1){
            button_comments.setVisibility(View.VISIBLE);
        }
    }


}

