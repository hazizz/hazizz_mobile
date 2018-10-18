package com.indeed.hazizz.Fragments.AuthFrags;

import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.indeed.hazizz.Activities.LoginActivity;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Hasher;
import com.indeed.hazizz.R;
import com.indeed.hazizz.RequestSenderRunnable;
import com.indeed.hazizz.Transactor;

import java.util.HashMap;

public class RegisterFragment extends Fragment {
    private String username;
    private String email;
    private String password;

    private EditText editText_username;
    private EditText editText_email;
    private EditText editText_password;
    private Button button_signup;

    private TextView textView_error;

    private TextView textView_toLogin;

    private View v;

    CustomResponseHandler responseHandler = new CustomResponseHandler() {
        @Override
        public void onResponse(HashMap<String, Object> response) {}
        @Override
        public void onPOJOResponse(Object response) {}
        @Override
        public void onFailure() {
        }

        @Override
        public void onErrorResponse(POJOerror error) {
            int errorCode = error.getErrorCode();
            if(errorCode == 31){

            }
            if(errorCode == 2){ // rossz adat
                textView_error.setText("A megadott adatok nem megfelelőek");

            }if(errorCode == 32){ // létezik ilyen nevű
                textView_error.setText("A felhasználónév már foglalt");
            }
            if(errorCode == 32){ // létezik ilyen nevű
                textView_error.setText("Az email címmel már regisztráltak");
            }
        }

        @Override
        public void onEmptyResponse() {

        }

        @Override
        public void onSuccessfulResponse() {
            Transactor.fragmentLogin(getFragmentManager().beginTransaction());
        }
    };

    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_register, container, false);
        editText_username = v.findViewById(R.id.editText_username);
        editText_email = v.findViewById(R.id.editText_email);
        editText_password = v.findViewById(R.id.editText_password);

        textView_error = v.findViewById(R.id.textView_error);
        textView_error.setTextColor(Color.rgb(255, 0, 0));

        button_signup = (Button) v.findViewById(R.id.button_signup);
        button_signup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(editText_username.getText().toString().length() >= 4 || editText_password.getText().toString().length() >= 8) {
                    username = editText_username.getText().toString();
                    email = editText_email.getText().toString();
                    password = Hasher.hashString(editText_password.getText().toString());
                    HashMap<String, Object> requestBody = new HashMap<>();

                    requestBody.put("username", username);
                    requestBody.put("password", password);
                    requestBody.put("emailAddress", email);

                    MiddleMan.newRequest(getContext(),"register", requestBody, responseHandler, null);
                }else{

                }
            }
        });
        textView_toLogin = v.findViewById(R.id.textView_toLogin);
        textView_toLogin.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view) {
                Transactor.fragmentLogin(getFragmentManager().beginTransaction());
            }
        });
        return v;
    }
}