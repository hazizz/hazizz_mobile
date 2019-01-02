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
import android.widget.Spinner;
import android.widget.TextView;

import com.indeed.hazizz.Activities.MainActivity;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOMembersProfilePic;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.POJO.Response.POJOsubject;
import com.indeed.hazizz.Communication.POJO.Response.PojoType;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgetTaskDetailed;

import com.indeed.hazizz.Communication.Strings;
import com.indeed.hazizz.Manager;
import com.indeed.hazizz.MeInfo;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.util.ArrayList;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class ViewTaskFragment extends Fragment implements AdapterView.OnItemSelectedListener{

    private Button button_comments;
    private Button button_delete;
    private Button button_edit;

    private int taskId, announcementId, groupId;
    private int subjectId = 0;

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
    private TextView textView_deadLine;

    private List<POJOsubject> subjects = new ArrayList<>();

    private CustomResponseHandler rh;

    private ArrayList<POJOsubject> subjectList = new ArrayList<POJOsubject>();

    private POJOsubject subject;

    private boolean goBackToMain;
    private int commentId;
    private boolean gotResponse = false;



    private View v;

    public ViewTaskFragment(){
    }

    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_viewtask, container, false);
        Log.e("hey", "im here lol");
        ((MainActivity)getActivity()).onFragmentCreated();
        textView_type = v.findViewById(R.id.textView_tasktype);
        textView_title = v.findViewById(R.id.textView_title);
        textView_description = v.findViewById(R.id.editText_description);
        textView_creatorName = v.findViewById(R.id.textView_creator);
        textView_subject = v.findViewById(R.id.textView_subject);
        textView_group = v.findViewById(R.id.textView_group);
        textView_deadLine = v.findViewById(R.id.textview_deadline);

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
                    }
                    @Override
                    public void onErrorResponse(POJOerror error) {
                        button_delete.setEnabled(true);
                    }
                };
                button_delete.setEnabled(false);

                EnumMap<Strings.Path, Object> vars = new EnumMap<>(Strings.Path.class);
                vars.put(Strings.Path.TASKID, taskId);
                if(subjectId != 0){vars.put(Strings.Path.SUBJECTID, subjectId);}
                else{vars.put(Strings.Path.GROUPID, groupId);}

                MiddleMan.newRequest(getActivity(),"deleteAT", null, rh, vars);

            }
        });

        button_edit.setOnClickListener(view -> {
            if(gotResponse) {
                Transactor.fragmentEditTask(getFragmentManager().beginTransaction(), Manager.GroupManager.getGroupId(),
                        Manager.GroupManager.getGroupName(), taskId, type, subjectId, title, descripiton, date,
                        Manager.DestManager.TOGROUP);
            }
        });

        button_comments = v.findViewById(R.id.button_comments);
        button_comments.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(subject == null){
                    Transactor.fragmentTaskCommentsByGroup(getFragmentManager().beginTransaction(), groupId, taskId);
                }else{
                    Transactor.fragmentTaskCommentsBySubject(getFragmentManager().beginTransaction(), subject.getId(), taskId);
                }
            }
        });

        Bundle bundle = this.getArguments();
        if (bundle != null) {
            taskId =  bundle.getInt("taskId");
            groupId = bundle.getInt("groupId");
            subjectId = bundle.getInt("subjectId");
            if(Manager.ProfilePicManager.getCurrentGroupId() != groupId || Manager.DestManager.getDest() == Manager.DestManager.TOMAIN){
                CustomResponseHandler responseHandler = new CustomResponseHandler() {
                    @Override
                    public void onPOJOResponse(Object response) {
                        Manager.ProfilePicManager.setCurrentGroupMembersProfilePic((HashMap<Integer, POJOMembersProfilePic>)response, groupId);
                    }
                    @Override
                    public void onFailure(Call<ResponseBody> call, Throwable t) {
                        Log.e("hey", "4");
                        Log.e("hey", "got here onFailure");
                    }
                };
                EnumMap<Strings.Path, Object> vars = new EnumMap<>(Strings.Path.class);
                vars.put(Strings.Path.GROUPID, Integer.toString(groupId));
                MiddleMan.newRequest(this.getActivity(),"getGroupMembersProfilePic", null, responseHandler, vars);
            }
            groupName = bundle.getString("groupName");
            goBackToMain = bundle.getBoolean("goBackToMain");

            Log.e("hey", "got IDs");
            Log.e("hey", taskId + ", " + groupId);
        }else{Log.e("hey", "bundle is null");}
        rh = new CustomResponseHandler() {
            @Override
            public void onPOJOResponse(Object response) {

                POJOgetTaskDetailed pojoResponse = (POJOgetTaskDetailed)response;

                Manager.GroupManager.setGroupId(pojoResponse.getGroup().getId());
                Manager.GroupManager.setGroupName(pojoResponse.getGroup().getName());

                groupId = pojoResponse.getGroup().getId();
                taskId = (int)pojoResponse.getId();
                type = pojoResponse.getType();
                subject = pojoResponse.getSubject();

                if(subject != null) {
                    subjectName = subject.getName();
                    subjectId = subject.getId();
                }

                type = pojoResponse.getType();
                title = pojoResponse.getTitle();
                descripiton = pojoResponse.getDescription();
                date = pojoResponse.getDueDate();
                groupName = pojoResponse.getGroup().getName();

                gotResponse = true;

                if(pojoResponse.getType().equals("test")){
                    textView_type.setText("teszt");
                }else{
                    textView_type.setText("házi feladat");
                }
                textView_title.setText(title);
                textView_description.setText(descripiton);
                String creatorUsername = pojoResponse.getCreator().getUsername();
                textView_creatorName.setText(creatorUsername);

                textView_subject.setText(subjectName);
                textView_group.setText(groupName);

                textView_deadLine.setText(date);

             /*   textView_deadLine.setText(pojoResponse.getDueDate()[0] + "." +
                        pojoResponse.getDueDate()[1] + "." +
                        pojoResponse.getDueDate()[2]); */

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
        };
        EnumMap<Strings.Path, Object> vars = new EnumMap<>(Strings.Path.class);
        vars.put(Strings.Path.TASKID, Integer.toString(taskId));

        if(subjectId == 0) {
            vars.put(Strings.Path.GROUPID, Integer.toString(groupId));
            MiddleMan.newRequest(this.getActivity(), "getTaskBy", null, rh, vars);
        }else{
            vars.put(Strings.Path.SUBJECTID, subjectId);
            MiddleMan.newRequest(this.getActivity(), "getTaskBy", null, rh, vars);
        }

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
