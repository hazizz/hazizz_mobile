package com.hazizz.droid.Fragments.Options;


import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.hazizz.droid.Activities.MainActivity;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOMembersProfilePic;
import com.hazizz.droid.Communication.POJO.Response.POJOauth;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.POJO.Response.POJOgroup;
import com.hazizz.droid.Communication.POJO.Response.PojoToken;
import com.hazizz.droid.Communication.Requests.ChangePassword;
import com.hazizz.droid.Communication.Requests.ElevationToken;
import com.hazizz.droid.Communication.Requests.RequestType.Login;
import com.hazizz.droid.Converter.Converter;
import com.hazizz.droid.Manager;
import com.hazizz.droid.R;
import com.hazizz.droid.SharedPrefs;
import com.hazizz.droid.Transactor;

import java.util.HashMap;
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
    private TextView textView_errorPasswordNotLongEnough;

    private String hashedNewPassword;


    private CustomResponseHandler authRh = new CustomResponseHandler() {
        @Override
        public void onPOJOResponse(Object response) {
            SharedPrefs.TokenManager.setToken(getContext() ,((POJOauth)response).getToken());
            SharedPrefs.TokenManager.setRefreshToken(getContext() ,((POJOauth)response).getRefresh());

            Transactor.fragmentOptions(getFragmentManager().beginTransaction());
            Toast.makeText(getActivity(), getString(R.string.success_changed_password),
                    Toast.LENGTH_LONG).show();

        }
    };

    private CustomResponseHandler changePassRh = new CustomResponseHandler() {
        @Override
        public void onSuccessfulResponse() {

            MiddleMan.newRequest(new Login(getActivity(), authRh, Manager.MeInfo.getProfileName(), hashedNewPassword));
        }

        @Override
        public void onErrorResponse(POJOerror error) {
            button_save.setEnabled(true);
        }
    };

    private CustomResponseHandler elevationRh = new CustomResponseHandler() {
        @Override
        public void onPOJOResponse(Object response) {
            String elevationToken = ((PojoToken)response).getToken();


            MiddleMan.newRequest(new ChangePassword(getActivity(), changePassRh, hashedNewPassword, elevationToken));
        }

        @Override
        public void onErrorResponse(POJOerror error) {
            if(error.getErrorCode() == 17){ // wrong token, try again

            }else if(error.getErrorCode() == 12){
                textView_errorCurrentPassword.setVisibility(View.VISIBLE);
            }
            button_save.setEnabled(true);
        }
    };


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_password, container, false);
        ((MainActivity)getActivity()).onFragmentCreated();

        textView_errorCurrentPassword = v.findViewById(R.id.textView_error_currentPassword);
        textView_errorNewPassword = v.findViewById(R.id.textView_error_newPassword);
        textView_errorPasswordNotLongEnough = v.findViewById(R.id.textView_error_password_short);
        editText_currentPassword = v.findViewById(R.id.editText_currentPassword);
      /*  editText_currentPassword.setOnFocusChangeListener(new View.OnFocusChangeListener() {
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
        });*/

        editText_currentPassword.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before,
                                      int count) {
                textView_errorCurrentPassword.setVisibility(View.INVISIBLE);
            }
            @Override public void beforeTextChanged(CharSequence s, int start, int count, int after) { }
            @Override public void afterTextChanged(Editable s) { }
        });

        editText_newPassword = v.findViewById(R.id.editText_newPassword);
        editText_newPassword.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (!editText_newPassword.getText().toString().equals(editText_againPassword.getText().toString())) {
                    textView_errorNewPassword.setVisibility(View.VISIBLE);
                }else{
                    textView_errorNewPassword.setVisibility(View.INVISIBLE);
                }
                if(editText_newPassword.getText().toString().length() < 8){
                    textView_errorPasswordNotLongEnough.setVisibility(View.VISIBLE);
                }else{
                    textView_errorPasswordNotLongEnough.setVisibility(View.INVISIBLE);

                }
            }
            @Override public void beforeTextChanged(CharSequence s, int start, int count, int after) { }
            @Override public void afterTextChanged(Editable s) { }
        });

        editText_againPassword = v.findViewById(R.id.editText_againPassword);
        editText_againPassword.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (!editText_againPassword.getText().toString().equals(editText_newPassword.getText().toString())) {
                    textView_errorNewPassword.setVisibility(View.VISIBLE);
                }else{
                    textView_errorNewPassword.setVisibility(View.INVISIBLE);
                }
            }
            @Override public void beforeTextChanged(CharSequence s, int start, int count, int after) { }
            @Override public void afterTextChanged(Editable s) { }
        });

        button_save = v.findViewById(R.id.button_save);
        button_save.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                button_save.setEnabled(false);
                String oldPassword = editText_currentPassword.getText().toString();
                String newPassword = editText_newPassword.getText().toString();
                String againPassword = editText_againPassword.getText().toString();
                if (newPassword.equals(againPassword)) {
                    if(newPassword.length() >= 8) {
                        String hashedOldPassword = Converter.hashString(oldPassword);
                        hashedNewPassword = Converter.hashString(newPassword);


                        MiddleMan.newRequest(new ElevationToken(getActivity(), elevationRh, hashedNewPassword));
                    }else{
                        textView_errorPasswordNotLongEnough.setVisibility(View.VISIBLE);
                    }
                }else{
                    textView_errorNewPassword.setVisibility(View.VISIBLE);
                    button_save.setEnabled(true);
                }
            }
        });
        return v;
    }

}
