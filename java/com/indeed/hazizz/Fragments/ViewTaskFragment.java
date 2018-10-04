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
import com.indeed.hazizz.Communication.POJO.Response.POJOsubject;
import com.indeed.hazizz.D8;
import com.indeed.hazizz.R;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class ViewTaskFragment extends Fragment implements AdapterView.OnItemSelectedListener{

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

    public ViewTaskFragment(){
    }

    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_createtask, container, false);
        Log.e("hey", "im here lol");



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
            public void onErrorResponse(HashMap<String, Object> errorResponse) {
                Log.e("hey", "onErrorResponse");
            }
        };
        return v;
    }

    @Override
    public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
    }

    @Override
    public void onNothingSelected(AdapterView<?> adapterView) {
    }
}
