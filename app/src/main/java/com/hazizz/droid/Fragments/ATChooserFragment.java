package com.hazizz.droid.Fragments;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import com.hazizz.droid.Fragments.MainTab.GroupsFragment;
import com.hazizz.droid.Fragments.ParentFragment.ParentFragment;
import com.hazizz.droid.Transactor;
import com.hazizz.droid.R;

public class ATChooserFragment extends ParentFragment {

    private View v;

    private Button button_task;
    private Button button_announcement;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_atchooser, container, false);

        fragmentSetup(R.string.title_choose_at);

        button_task = v.findViewById(R.id.button_task);
        button_task.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view) {
                Transactor.fragmentCreatorAT(getFragmentManager().beginTransaction(), GroupsFragment.Dest.TOCREATETASK);

                //    Transactor.fragmentCreateTask(getFragmentManager().beginTransaction(), Manager.GroupManager.getGroupId(), Manager.GroupManager.getGroupName(), Manager.DestManager.TOMAIN);
               // Transactor.fragmentCreateTask(getFragmentManager().beginTransaction(), Strings.Dest.TOMAIN);
            }
        });
        button_announcement = v.findViewById(R.id.button_announcement);
        button_announcement.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view) {
                Transactor.fragmentCreatorAT(getFragmentManager().beginTransaction(), GroupsFragment.Dest.TOCREATEANNOUNCEMET);
                //  Transactor.fragmentCreateAnnouncement(getFragmentManager().beginTransaction(), Manager.GroupManager.getGroupId(), Manager.GroupManager.getGroupName(), Manager.DestManager.TOMAIN);
             //   Transactor.fragmentCreateAnnouncement(getFragmentManager().beginTransaction(), Strings.Dest.TOMAIN);
            }
        });
        return v;
    }
}