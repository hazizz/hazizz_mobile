package com.hazizz.droid.Fragments.Options;


import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.hazizz.droid.Activities.MainActivity;
import com.hazizz.droid.Communication.POJO.Response.POJOgroup;
import com.hazizz.droid.Converter.Converter;
import com.hazizz.droid.Manager;
import com.hazizz.droid.R;

import java.util.List;

public class PasswordFragment extends Fragment {

    public List<POJOgroup> groups;
    private View v;

    private EditText editText_currentPassword;
    private EditText editText_newPassword;
    private EditText editText_againPassword;
    private Button button_save;
    private TextView textView_errorNewPassword;
    private TextView textView_errorCurrentPassword;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_password, container, false);
        ((MainActivity)getActivity()).onFragmentCreated();

        textView_errorCurrentPassword = v.findViewById(R.id.textView_error_currentPassword);
        textView_errorNewPassword = v.findViewById(R.id.textView_error_newPassword);

        editText_currentPassword = v.findViewById(R.id.editText_currentPassword);
        editText_currentPassword.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View view, boolean hasFocus) {
                if (!hasFocus) {
                    if(!currentPasswordCorrect()){
                        textView_errorCurrentPassword.setVisibility(View.VISIBLE);
                    }else{
                        textView_errorCurrentPassword.setVisibility(View.INVISIBLE);
                    }
                }
            }
        });


        editText_newPassword = v.findViewById(R.id.editText_newPassword);
        editText_newPassword.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View view, boolean hasFocus) {
                if(!hasFocus) {
                    if (!editText_newPassword.getText().toString().equals(editText_againPassword.getText().toString())) {
                        textView_errorNewPassword.setVisibility(View.VISIBLE);
                    }else{
                        textView_errorNewPassword.setVisibility(View.INVISIBLE);
                    }
                }
            }
        });
        editText_againPassword = v.findViewById(R.id.editText_againPassword);
        editText_againPassword.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View view, boolean hasFocus) {
                if(!hasFocus) {
                    if (!editText_againPassword.getText().toString().equals(editText_newPassword.getText().toString())) {
                        textView_errorNewPassword.setVisibility(View.VISIBLE);
                    }else{
                        textView_errorNewPassword.setVisibility(View.INVISIBLE);
                    }
                }
            }
        });
        button_save = v.findViewById(R.id.button_save);
        button_save.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(currentPasswordCorrect()) {
                    String newPassword = editText_newPassword.getText().toString();
                    String againPassword = editText_againPassword.getText().toString();
                    if (newPassword.equals(againPassword)) {
                        String hashedPassword = Converter.hashString(newPassword);




                    }else{
                        textView_errorNewPassword.setVisibility(View.VISIBLE);
                    }
                }else{
                    textView_errorCurrentPassword.setVisibility(View.VISIBLE);
                }
            }
        });

        return v;
    }

    private boolean currentPasswordCorrect(){
        return editText_currentPassword.getText().toString().equals(Manager.MeInfo.getPassword());
    }


}
