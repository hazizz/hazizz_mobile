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
import android.widget.Spinner;
import android.widget.TextView;

import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.POJO.Response.POJOsubject;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgetTaskDetailed;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class ViewTaskFragment extends Fragment implements AdapterView.OnItemSelectedListener{

    private int groupId;
    private int taskId;
    private String groupName;

    private Spinner subject_spinner;

    private TextView type;
    private TextView title;
    private TextView description;
    private TextView creatorName;
    private TextView subject;
    private TextView deadLine;

    private List<POJOsubject> subjects = new ArrayList<>();

    private CustomResponseHandler rh;

    private ArrayList<POJOsubject> subjectList = new ArrayList<POJOsubject>();

    private View v;

    public ViewTaskFragment(){
    }

    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_viewtask, container, false);
        Log.e("hey", "im here lol");

        type = v.findViewById(R.id.textView_tasktype);
        title = v.findViewById(R.id.textView_title);
        description = v.findViewById(R.id.textView_description);
        creatorName = v.findViewById(R.id.textView_creator);
        subject = v.findViewById(R.id.textView_title);
        deadLine = v.findViewById(R.id.textview_deadline);


        Bundle bundle = this.getArguments();
        if (bundle != null) {
            taskId =  bundle.getInt("taskId");
            groupId = bundle.getInt("groupId");
            groupName = bundle.getString("groupName");

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
                type.setText(((POJOgetTaskDetailed)response).getType());
                title.setText(((POJOgetTaskDetailed)response).getTitle());
                description.setText(((POJOgetTaskDetailed)response).getDescription());
                creatorName.setText(((POJOgetTaskDetailed)response).getCreator().getUsername());
              //  subject.setText(((POJOgetTaskDetailed)response).getSubjectData().getName());
                subject.setText(((POJOgetTaskDetailed)response).getSubjectData().getName());

                deadLine.setText(((POJOgetTaskDetailed)response).getDueDate().get(0) + "." +
                        ((POJOgetTaskDetailed)response).getDueDate().get(1) + "." +
                        ((POJOgetTaskDetailed)response).getDueDate().get(2));
            }

            @Override
            public void onFailure() {
                Log.e("hey", "4");
                Log.e("hey", "got here onFailure");
                Log.e("hey", "task created");
            }

            @Override
            public void onErrorResponse(POJOerror error) {
                Log.e("hey", "onErrorResponse");
            }

            @Override
            public void onNoResponse() {

            }
        };
        HashMap<String, Object> vars = new HashMap<>();
        vars.put("taskId", taskId);
        vars.put("groupId", groupId);
        MiddleMan.newRequest(this.getActivity(), "getTask", null, rh, vars);

        return v;
    }

    @Override
    public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
    }

    @Override
    public void onNothingSelected(AdapterView<?> adapterView) {
    }

    public void toCreateTask(){
        Log.e("hey", "toCreateTask in viewtaskFrag" + groupId);
        Transactor.fragmentCreateTask(getFragmentManager().beginTransaction(),groupId, groupName);
    }
  /*  public void toCreateTask(){
        Transactor.fragmentCreateTask(getFragmentManager().beginTransaction(),groupID, groupName);
        Log.e("hey", "called 123");
    } */
}
