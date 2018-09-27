package com.indeed.hazizz.Fragments;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.R;

import java.util.ArrayList;
import java.util.HashMap;

public class CreateTaskFragment extends Fragment{

    private int groupId;

    private EditText taskType;
    private EditText taskTitle;
    private EditText description;
    private Button button_send;

    private CustomResponseHandler responseHandler;

    private View v;

    public CreateTaskFragment(){

    }

    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_createtask, container, false);
        Log.e("hey", "im here lol");

        button_send = (Button)v.findViewById(R.id.button_send1);
        taskType = v.findViewById(R.id.taskType);
        taskTitle = v.findViewById(R.id.taskTitle);
        description = v.findViewById(R.id.description);

        button_send.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Log.e("hey", "rick rolled");
                createTask();
            }
        });
        responseHandler = new CustomResponseHandler() {
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
            public void onErrorResponse(HashMap<String, Object> errorResponse) {
                Log.e("hey", "onErrorResponse");
            }
        };
        return v;
    }

    private void createTask(){
        Log.e("hey", "creating task");
        HashMap<String, Object> requestBody = new HashMap<>();
/*
        requestBody.put("taskType", taskType.getText());
        requestBody.put("taskTitle", taskTitle.getText());
        requestBody.put("description", description.getText());
*/
        requestBody.put("taskType", "Homework");
        requestBody.put("taskTitle", "title");
        requestBody.put("description", "description");

        requestBody.put("subjectId", "1");
        requestBody.put("dueDate", "2018-09-28");
        HashMap<String, Object> vars = new HashMap<>();
        vars.put("id", 2);

        MiddleMan.newRequest(this.getActivity(), "createTask", requestBody, responseHandler, vars);
       // MiddleMan.newRequest(this.getActivity(), "getSubjects", requestBody, responseHandler, vars);



        }

}
