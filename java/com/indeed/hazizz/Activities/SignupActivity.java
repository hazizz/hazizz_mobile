package com.indeed.hazizz.Activities;

import com.indeed.hazizz.Activities.LoginActivity;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Hasher;
import com.indeed.hazizz.R;
import com.indeed.hazizz.RequestSenderRunnable;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.Button;
import android.widget.TextView;

import java.util.HashMap;

public class SignupActivity extends AppCompatActivity {

    private String username;
    private String email;
    private String password;

    private EditText usernameET;
    private EditText emailET;
    private EditText passwordET;
    private Button button_signup;

    private TextView textView;
    private TextView toLoginActivity;

    private Toolbar toolbar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_signup);
        usernameET = findViewById(R.id.editText_username);
        emailET = findViewById(R.id.editText_email);
        passwordET = findViewById(R.id.editText_password);
        textView = findViewById(R.id.textView);
        toolbar = findViewById(R.id.toolbar);

        button_signup = (Button) findViewById(R.id.button_signup);
        button_signup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                boolean asd = true;
                if(usernameET.getText().toString().length() >= 4 || passwordET.getText().toString().length() >= 8) {
                    username = usernameET.getText().toString();
                    email = emailET.getText().toString();
                    password = passwordET.getText().toString();
                    textView.append("username: " + username + "\n email: " + email + "\n password: " + password);
                    HashMap<String, Object> requestBody = new HashMap<>();

                    requestBody.put("username", username);
                    requestBody.put("password", Hasher.hashString(password));
                    requestBody.put("emailAddress", email);

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
                            textView.append("\n errorCode: " + error.getErrorCode());
                            Log.e("hey", "got here");
                        }
                        @Override
                        public void onEmptyResponse() {
                            switchToLoginActivity();
                        }

                        @Override
                        public void onSuccessfulResponse() {

                        }
                    };
                    MiddleMan.newRequest(getBaseContext(),"register", requestBody, responseHandler, null);
                }else{

                }
            }
        });
     /*   textView_toLogin = findViewById(R.id.toLoginActivity);
        textView_toLogin.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view) {
                switchToLoginActivity();
            }
        }); */


    }
    private void switchToLoginActivity(){
        Intent i = new Intent(this, LoginActivity.class);
        startActivity(i);
    }
}

