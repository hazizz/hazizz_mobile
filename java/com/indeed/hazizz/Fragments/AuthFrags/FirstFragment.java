package com.indeed.hazizz.Fragments.AuthFrags;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.indeed.hazizz.Activities.MainActivity;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

public class FirstFragment extends Fragment {

    private View v;

    private TextView textView_login;
    private TextView textView_register;



    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_first, container, false);

        textView_login = v.findViewById(R.id.textView_login);
        textView_login.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view) {
                Transactor.fragmentLogin(getFragmentManager().beginTransaction());
            }
        });
        textView_register = v.findViewById(R.id.textView_register);
        textView_register.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view) {
                Transactor.fragmentRegister(getFragmentManager().beginTransaction());
            }
        });
        return v;
    }
}