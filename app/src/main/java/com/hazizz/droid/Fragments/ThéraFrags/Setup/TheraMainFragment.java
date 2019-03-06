package com.hazizz.droid.Fragments.ThéraFrags.Setup;

import android.content.Context;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.hazizz.droid.Fragments.ParentFragment.ParentFragment;
import com.hazizz.droid.R;
import com.hazizz.droid.Transactor;

public class TheraMainFragment extends ParentFragment {

    private TextView textView_grades;
    private TextView textView_schedules;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_th_main, container, false);
        fragmentSetup(R.string.title_thera);

        textView_grades = v.findViewById(R.id.textView_grades);
        textView_grades.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Transactor.fragmentThGrades(getFragmentManager().beginTransaction());
            }
        });
        textView_schedules = v.findViewById(R.id.textView_schedules);
        textView_schedules.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Transactor.fragmentThSchedules(getFragmentManager().beginTransaction());
            }
        });


        return v;
    }
}
