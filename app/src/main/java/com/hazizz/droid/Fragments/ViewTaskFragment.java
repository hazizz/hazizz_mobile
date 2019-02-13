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
import android.widget.Spinner;
import android.widget.TextView;

import com.crashlytics.android.answers.Answers;
import com.crashlytics.android.answers.CustomEvent;
import com.hazizz.droid.Activities.MainActivity;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.GetUserPermissionInGroup;
import com.hazizz.droid.Communication.POJO.Response.POJOMembersProfilePic;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.POJO.Response.POJOsubject;
import com.hazizz.droid.Communication.POJO.Response.POJOuser;
import com.hazizz.droid.Communication.POJO.Response.PojoPermisionUsers;
import com.hazizz.droid.Communication.POJO.Response.PojoType;
import com.hazizz.droid.Communication.POJO.Response.getTaskPOJOs.POJOgetTaskDetailed;
import com.hazizz.droid.Communication.Requests.DeleteAT;
import com.hazizz.droid.Communication.Requests.GetAT;
import com.hazizz.droid.Communication.Requests.GetGroupMemberPermisions;
import com.hazizz.droid.Communication.Requests.GetGroupMembersProfilePic;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.D8;
import com.hazizz.droid.Manager;
import com.hazizz.droid.Transactor;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.R;

import java.util.HashMap;

public class ViewTaskFragment extends Fragment implements AdapterView.OnItemSelectedListener{

    private Button button_comments;
    private Button button_delete;
    private Button button_edit;


    private short enable_button_comment = 0;
    private int creatorId, groupId, taskId;
    private int subjectId = 0;

    public static final boolean myMode = true;
    public static final boolean publicMode = false;

    private boolean isMyMode;

    private String groupName;
    private PojoType type;
    private String subjectName;
    private String title;
    private String descripiton;
    private String date;

    private Spinner subject_spinner;

    private TextView textView_type;
    private TextView textView_title;
    private TextView textView_description;
    private TextView textView_creatorName;
    private TextView textView_subject;
    private TextView textView_group;
    private TextView textView_group_;
    private TextView textView_deadLine;

    private CustomResponseHandler rh;

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

    private POJOsubject subject;

    private boolean goBackToMain;
    private boolean gotResponse = false;

    private View v;

    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_viewtask, container, false);
        Log.e("hey", "im here lol");
        ((MainActivity)getActivity()).onFragmentCreated();
        getActivity().setTitle(R.string.title_fragment_view_task);
        textView_type = v.findViewById(R.id.textView_tasktype);
        textView_title = v.findViewById(R.id.textView_title);
        textView_description = v.findViewById(R.id.editText_description);
        textView_creatorName = v.findViewById(R.id.textView_creator_);
        textView_subject = v.findViewById(R.id.textView_subject);
        textView_group = v.findViewById(R.id.textView_group);
        textView_group_ = v.findViewById(R.id.textView_group_);
        textView_deadLine = v.findViewById(R.id.textview_deadline);
        textView_deadLine.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Transactor.fragmentDialogDateViewer(getFragmentManager().beginTransaction(), date);
            }
        });

        button_delete = v.findViewById(R.id.button_delete);
        button_edit = v.findViewById(R.id.button_edit);


        button_delete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                CustomResponseHandler rh = new CustomResponseHandler() {
                    @Override
                    public void onSuccessfulResponse() {
                        if(Manager.DestManager.getDest() == Manager.DestManager.TOGROUP) {
                            Transactor.fragmentGroupTask(getFragmentManager().beginTransaction(), Manager.GroupManager.getGroupId(), Manager.GroupManager.getGroupName());
                        } else{
                            Transactor.fragmentMainTask(getFragmentManager().beginTransaction());
                        }
                        Answers.getInstance().logCustom(new CustomEvent("delete task")
                                .putCustomAttribute("status", "success")
                        );
                    }
                    @Override
                    public void onErrorResponse(POJOerror error) {
                        button_delete.setEnabled(true);
                        Answers.getInstance().logCustom(new CustomEvent("delete task")
                                .putCustomAttribute("status", error.getErrorCode())
                        );
                    }
                };
                button_delete.setEnabled(false);

                MiddleMan.newRequest(new DeleteAT(getActivity(), rh, Strings.Path.TASKS, taskId));

            }
        });

        button_edit.setOnClickListener(view -> {
            if(gotResponse) {
                Transactor.fragmentEditTask(getFragmentManager().beginTransaction(), groupId,
                        Manager.GroupManager.getGroupName(), taskId, type, subjectId, subjectName, title, descripiton, date,
                        Manager.DestManager.TOGROUP);
            }
        });
        button_comments = v.findViewById(R.id.button_comments);
        button_comments.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Transactor.fragmentCommentSection(getFragmentManager().beginTransaction(), Strings.Path.TASKS.toString(), taskId);

            }
        });

        Bundle bundle = this.getArguments();
        if (bundle != null) {
            taskId = bundle.getInt(Strings.Path.TASKID.toString());

            isMyMode = bundle.getBoolean("mode");
            goBackToMain = bundle.getBoolean("goBackToMain");

        }else{Log.e("hey", "bundle is null");}
        rh = new CustomResponseHandler() {
            @Override
            public void onPOJOResponse(Object response) {

                POJOgetTaskDetailed pojoResponse = (POJOgetTaskDetailed) response;

                if(!isMyMode){
                    if (pojoResponse.getGroup() != null) {
                        groupName = pojoResponse.getGroup().getName();
                        groupId = pojoResponse.getGroup().getId();
                        Manager.GroupManager.setGroupId(groupId);
                        Manager.GroupManager.setGroupName(groupName);
                    }

                    CustomResponseHandler r1 = new CustomResponseHandler() {
                        @Override
                        public void onPOJOResponse(Object response) {
                            PojoPermisionUsers pojoPermisionUser = (PojoPermisionUsers) response;
                            if (pojoPermisionUser != null) {
                                if (pojoPermisionUser.getOWNER() != null) {
                                    for (POJOuser u : pojoPermisionUser.getOWNER()) {
                                        Manager.GroupRankManager.setRank(u.getId(), Strings.Rank.OWNER);
                                    }
                                }
                                if (pojoPermisionUser.getMODERATOR() != null) {
                                    for (POJOuser u : pojoPermisionUser.getMODERATOR()) {
                                        Log.e("hey", "555: MODI");
                                        Manager.GroupRankManager.setRank(u.getId(), Strings.Rank.MODERATOR);
                                    }
                                }
                                if (pojoPermisionUser.getUSER() != null) {
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
                    MiddleMan.newRequest(new GetGroupMemberPermisions(getActivity(), r1, groupId));

                    creatorId = (int) pojoResponse.getCreator().getId();

                    MiddleMan.newRequest(new GetUserPermissionInGroup(getActivity(), permissionRh, groupId, (int) Manager.MeInfo.getId()));

                    if (Manager.ProfilePicManager.getCurrentGroupId() != groupId || Manager.DestManager.getDest() == Manager.DestManager.TOMAIN) {
                        CustomResponseHandler responseHandler = new CustomResponseHandler() {
                            @Override
                            public void onPOJOResponse(Object response) {
                                Manager.ProfilePicManager.setCurrentGroupMembersProfilePic((HashMap<Integer, POJOMembersProfilePic>) response, groupId);
                                enable_button_comment++;
                                visibleIfEnabled_button_comment();
                            }
                        };
                        MiddleMan.newRequest(new GetGroupMembersProfilePic(getActivity(), responseHandler, groupId));
                    } else {
                        enable_button_comment++;
                        visibleIfEnabled_button_comment();
                    }
                }else{// is my task
                    getActivity().setTitle(R.string.view_mytask);
                    textView_group_.setVisibility(View.GONE);
                }

                taskId = (int)pojoResponse.getId();
                type = pojoResponse.getType();
                subject = pojoResponse.getSubject();

                if(subject != null) {
                    subjectName = subject.getName();
                    subjectId = subject.getId();
                }else{
                    subjectName = getString(R.string.subject_none);
                }

                type = pojoResponse.getType();
                title = pojoResponse.getTitle();
                descripiton = pojoResponse.getDescription();
                date = pojoResponse.getDueDate();


                gotResponse = true;

                int typeId = (int)pojoResponse.getType().getId();

                String[] taskTypeArray = getResources().getStringArray(R.array.taskTypes);
                textView_type.setText(taskTypeArray[typeId-1]);


                textView_title.setText(title);
                textView_description.setText(descripiton);

                textView_creatorName.setText(pojoResponse.getCreator().getDisplayName());

                textView_subject.setText(subjectName);
                textView_group.setText(groupName);

                textView_deadLine.setText(D8.textToDate(date).getMainFormat());

            }
        };
        MiddleMan.newRequest(new GetAT(getActivity(), rh, Strings.Path.TASKS, taskId));

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

    public int getGroupId(){ return groupId; }
    public String getGroupName(){ return groupName; }
    public boolean getGoBackToMain(){ return goBackToMain; }


    public void visibleIfEnabled_button_comment(){
        if(enable_button_comment > 1){
            button_comments.setVisibility(View.VISIBLE);
        }
    }
}
