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
import com.hazizz.droid.Listener.OnBackPressedListener;
import com.hazizz.droid.R;
import com.hazizz.droid.SharedPrefs;
import com.hazizz.droid.Transactor;

public class TheraMainFragment extends ParentFragment {

    private TextView button_grades;
    private TextView button_schedules;

    private TextView textView_username;
    private TextView textView_username_;
    private TextView textView_switch_account;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_th_main, container, false);

        fragmentSetup(R.string.title_thera);
        setOnBackPressedListener(new OnBackPressedListener() {
            @Override
            public void onBackPressed() {
                Transactor.fragmentMain(getFragmentManager().beginTransaction());
            }
        });

        textView_username = v.findViewById(R.id.textView_username);
        textView_username_ = v.findViewById(R.id.textView_username_);

        Context context = getContext();

        String username = SharedPrefs.ThLoginData.getUsername(context, SharedPrefs.ThSessionManager.getSessionId(context));
        if(username == null || username.equals("")){
            textView_username_.setVisibility(View.INVISIBLE);
        }
        if(SharedPrefs.ThSessionManager.getSessionId(context) != 0 && username != null){
            textView_username.setText(username);
        }else{
            Transactor.fragmentThUsers(getFragmentManager().beginTransaction());
        }

        button_grades = v.findViewById(R.id.button_grades);
        button_grades.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Transactor.fragmentThGrades(getFragmentManager().beginTransaction());
            }
        });
        button_schedules = v.findViewById(R.id.button_schedules);
        button_schedules.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Transactor.fragmentThSchedules(getFragmentManager().beginTransaction());
            }
        });

        textView_switch_account = v.findViewById(R.id.textView_switch_account);
        textView_switch_account.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
             //   SharedPrefs.ThLoginData.clearData(context);
                SharedPrefs.ThSessionManager.clearSession(context);
                Transactor.fragmentThUsers(getFragmentManager().beginTransaction());
            }
        });
        return v;
    }
}
