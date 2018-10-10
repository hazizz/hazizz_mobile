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
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;

import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.POJO.Response.POJOsubject;
import com.indeed.hazizz.D8;
import com.indeed.hazizz.FragTag;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class CreateTaskFragment extends Fragment implements AdapterView.OnItemSelectedListener{

    private int groupId;

    private Spinner subject_spinner;

    private Spinner taskType;
    private EditText taskTitle;
    private EditText description;
    private Button button_send;

    private List<POJOsubject> subjects = new ArrayList<>();

    private CustomResponseHandler rh_subjects;
    private CustomResponseHandler rh_taskTypes;

    private ArrayList<POJOsubject> subjectList = new ArrayList<POJOsubject>();

    private View v;

    public CreateTaskFragment(){
    }

    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_createtask, container, false);
        Log.e("hey", "im here lol");

        groupId = getArguments().getInt("groupId");
        Log.e("hey", "in createtaskFrag construvtor: " + groupId);

        subject_spinner = (Spinner)v.findViewById(R.id.subject_spinner);

        button_send = (Button)v.findViewById(R.id.button_send1);
        taskType = (Spinner)v.findViewById(R.id.taskType_spinner);
        taskTitle = v.findViewById(R.id.taskTitle);
        description = v.findViewById(R.id.textView_description);
        // tasktype spinner
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(getContext(), R.array.taskTypes, android.R.layout.simple_spinner_item);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        taskType.setAdapter(adapter);

        // subject spinner
        ArrayAdapter<POJOsubject> s_adapter = new ArrayAdapter<POJOsubject>(getContext(), android.R.layout.simple_spinner_item);
        s_adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        subject_spinner.setAdapter(s_adapter);
        s_adapter.notifyDataSetChanged();
        subject_spinner.setOnItemSelectedListener(this);

        button_send.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Log.e("hey", "rick rolled");
                createTask();
            }
        });
        rh_taskTypes = new CustomResponseHandler() {
            @Override
            public void onResponse(HashMap<String, Object> response) {
                Log.e("hey", "got regular response");

            }

            @Override
            public void onPOJOResponse(Object response) {
                Log.e("hey", "got POJOresponse");
            }

            @Override
            public void onFailure() {
                Log.e("hey", "4");
                Log.e("hey", "got here onFailure");
                Log.e("hey", "task created");
            }

            @Override
            public void onErrorResponse(POJOerror error) {
                Log.e("hey", error.getMessage());
            }

            @Override
            public void onNoResponse() {
                toMainGroupFrag();
            }
        };
        rh_subjects = new CustomResponseHandler() {
            @Override
            public void onResponse(HashMap<String, Object> response) {
                Log.e("hey", "got regular response");
            }

            @Override
            public void onPOJOResponse(Object response) {
                subjects = (ArrayList<POJOsubject>)response;
                for(POJOsubject s : subjects){
                    s_adapter.add(s);
                    s_adapter.notifyDataSetChanged();
                }
            }

            @Override
            public void onFailure() {
                Log.e("hey", "4");
                Log.e("hey", "got here onFailure");
                Log.e("hey", "subject fail");
            }

            @Override
            public void onErrorResponse(POJOerror error) {
                Log.e("hey", "onErrorResponse");
            }

            @Override
            public void onNoResponse() {
                Log.e("hey", "there is no repsonse");
            }
        };

        getSubjects();
        return v;
    }

    private void getSubjects(){
        HashMap<String, Object> vars = new HashMap<>();
        vars.put("id", groupId);
        MiddleMan.newRequest(this.getActivity(), "getSubjects", null, rh_subjects, vars);
    }

    private void createTask(){
        Log.e("hey", "creating task");
        HashMap<String, Object> requestBody = new HashMap<>();

        requestBody.put("taskType", taskType.getSelectedItem().toString());
        requestBody.put("taskTitle", taskTitle.getText().toString());
        requestBody.put("description", description.getText().toString());
        requestBody.put("subjectId", ((POJOsubject) subject_spinner.getSelectedItem()).getId());//((POJOsubject) subject_spinner.getSelectedItem()).getId());
        requestBody.put("dueDate", D8.getDateTomorrow());

        HashMap<String, Object> vars = new HashMap<>();
        vars.put("id", groupId);

        MiddleMan.newRequest(this.getActivity(), "createTask", requestBody, rh_taskTypes, vars);
        }

    @Override
    public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
    }

    @Override
    public void onNothingSelected(AdapterView<?> adapterView) {
    }



    void toMainGroupFrag(){
        Transactor.makeTransaction(new GroupMainFragment(), getFragmentManager().beginTransaction(), FragTag.groupMain.toString(), groupId);
    }
}
