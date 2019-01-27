package com.hazizz.droid.Fragments;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.hazizz.droid.Manager;
import com.hazizz.droid.Transactor;
import com.hazizz.droid.R;

public class ATChooserFragment extends Fragment {

    private View v;

    private TextView textView_task;
    private TextView textView_announcement;



    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_atchooser, container, false);

        textView_task = v.findViewById(R.id.textView_task);
        textView_task.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view) {
            //    Transactor.fragmentCreateTask(getFragmentManager().beginTransaction(), Manager.GroupManager.getGroupId(), Manager.GroupManager.getGroupName(), Manager.DestManager.TOMAIN);
                Transactor.fragmentToATChooser(getFragmentManager().beginTransaction(), Manager.DestManager.TOCREATETASK);
            }
        });
        textView_announcement = v.findViewById(R.id.textView_announcement);
        textView_announcement.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view) {
              //  Transactor.fragmentCreateAnnouncement(getFragmentManager().beginTransaction(), Manager.GroupManager.getGroupId(), Manager.GroupManager.getGroupName(), Manager.DestManager.TOMAIN);
                Transactor.fragmentToATChooser(getFragmentManager().beginTransaction(), Manager.DestManager.TOCREATEANNOUNCEMENT);

            }
        });
        return v;
    }
}