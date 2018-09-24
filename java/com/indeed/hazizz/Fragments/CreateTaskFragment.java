package com.indeed.hazizz.Fragments;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.indeed.hazizz.Communication.POJO.Response.POJOgroup;
import com.indeed.hazizz.R;

import java.util.ArrayList;

public class CreateTaskFragment extends Fragment{

    private int groupId;

    private View v;

    public CreateTaskFragment(){

    }

    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_group, container, false);
        Log.e("hey", "im here lol");


        return v;
    }

    void createTask(){

    }

}
