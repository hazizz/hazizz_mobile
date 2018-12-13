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
import com.indeed.hazizz.Communication.POJO.Response.POJOgroup;
import com.indeed.hazizz.Communication.POJO.Response.POJOsubject;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgetTaskDetailed;

import com.indeed.hazizz.Manager;
import com.indeed.hazizz.MeInfo;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class ViewTaskFragment extends Fragment implements AdapterView.OnItemSelectedListener{

    private Button button_comments;
    private Button button_delete;
    private Button button_edit;

    private int taskId;
    private int groupId;
    private String groupName;
    private String type;
    private String subjectName;
    private int subjectId;
    private String title;
    private String descripiton;
    private int[] date;



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
                if(gotResponse){
                 //   Transactor.fragmentCommentSection(getFragmentManager().beginTransaction(), commentId);//commentId);
                    HashMap<String, Object> vars = new HashMap<>();
                    vars.put("groupId", groupId);
                    vars.put("taskId", taskId);
                    CustomResponseHandler rh = new CustomResponseHandler() {
                        @Override
                        public void onSuccessfulResponse() {
                            if(Manager.DestManager.getDest() == Manager.DestManager.TOGROUP) {
                                Transactor.fragmentGroupTask(getFragmentManager().beginTransaction(), Manager.GroupManager.getGroupId(), Manager.GroupManager.getGroupName());
                            } else{
                                Transactor.fragmentMainTask(getFragmentManager().beginTransaction());
                            }
                        }
                    };
                    MiddleMan.newRequest(getActivity(),"deleteTask", null, rh, vars);
                }
            }
        });

        button_edit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(gotResponse){
                    Transactor.fragmentEditTask(getFragmentManager().beginTransaction(), Manager.GroupManager.getGroupId(), Manager.GroupManager.getGroupName(), taskId,type, subjectId, title, descripiton, date);//commentId);
                }
            }
        });

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
            taskId =  bundle.getInt("taskId");
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
            Log.e("hey", taskId + ", " + groupId);
        }else{Log.e("hey", "bundle is null");}
        rh = new CustomResponseHandler() {
            @Override
            public void onResponse(HashMap<String, Object> response) {
                Log.e("hey", "got regular response");

            }

            @Override
            public void onPOJOResponse(Object response) {

                POJOgetTaskDetailed pojoResponse = (POJOgetTaskDetailed)response;

                Manager.GroupManager.setGroupId(pojoResponse.getGroup().getId());
                Manager.GroupManager.setGroupName(pojoResponse.getGroup().getName());

                groupId = pojoResponse.getGroup().getId();
                taskId = (int)pojoResponse.getId();

                type = pojoResponse.getType();
                subjectName = pojoResponse.getSubjectData().getName();
                subjectId = (int)pojoResponse.getSubjectData().getId();
                type = pojoResponse.getType();
                title = pojoResponse.getTitle();
                descripiton = pojoResponse.getDescription();
                date = pojoResponse.getDueDate();


                commentId = (int)pojoResponse.getSections().get(0).getId();
                gotResponse = true;
                if(pojoResponse.getType().equals("test")){
                    textView_type.setText("teszt");
                }else{
                    textView_type.setText("házi feladat");
                }
                textView_title.setText("Cím: " + pojoResponse.getTitle());
                textView_description.setText(pojoResponse.getDescription());
                String creatorUsername = pojoResponse.getCreator().getUsername();
                textView_creatorName.setText(pojoResponse.getCreator().getUsername());

                //  subject.setText(pojoResponse.getSubjectData().getName());
                textView_subject.setText(creatorUsername);
                textView_group.setText(pojoResponse.getGroup().getName());

                textView_deadLine.setText(pojoResponse.getDueDate()[0] + "." +
                        pojoResponse.getDueDate()[1] + "." +
                        pojoResponse.getDueDate()[2]);

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
            //    textView_noContent.setText("Nincs internet kapcsolat");

            }
        };
        HashMap<String, Object> vars = new HashMap<>();
        vars.put("taskId", Integer.toString(taskId));
        vars.put("groupId", Integer.toString(groupId));
        MiddleMan.newRequest(this.getActivity(), "getTask", null, rh, vars);

        return v;
    }

    @Override
    public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
    }

    @Override
    public void onNothingSelected(AdapterView<?> adapterView) {
    }

  /*  public void toCreateTask(){
        Transactor.fragmentCreateTask(getFragmentManager().beginTransaction(),groupID, groupName);
        Log.e("hey", "called 123");
    } */

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
