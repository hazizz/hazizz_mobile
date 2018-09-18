package com.indeed.hazizz.Activities;

import com.indeed.hazizz.Activities.LoginActivity;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.MyCallback;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.ResponseBodies;
import com.indeed.hazizz.Communication.ResponseHandler;
import com.indeed.hazizz.R;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
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

    private MyCallback<ResponseBodies.Error> errorCallback;

    private static final String BASE_URL = "http://80.98.42.103:8080/";
    private ResponseHandler responseHandler = new ResponseHandler() {

        @Override
        public void on401() {
            textView.append("created");
        }

        @Override
        public void on400() {
            textView.append("Registration was successful");
        }

        /* @Override
         public void onInvalidData(){

         } */
        @Override
        public void onUnknowError() {
            textView.append("Unknown Error");
        }

   /*     @Override
        public void onInvalidData() {

        } */

        @Override
        public void onDatabaseError() {

        }

        @Override
        public void onPathVariableMissing() {

        }

        @Override
        public void onForbidden() {

        }

        @Override
        public void onGeneralAuthenticationError() {
            textView.append("onGeneralAuthenticationError");
        }

        @Override
        public void onInvalidPassword() {

        }

        @Override
        public void onAccountLocked() {

        }

        @Override
        public void onAccountDisabled() {

        }

        @Override
        public void onAccountExpired() {

        }

        @Override
        public void onUnkownPermission() {

        }

        @Override
        public void onBadAuthenticationRequest() {

        }

        @Override
        public void onGeneralUserError() {

        }

        @Override
        public void onUserNotFound() {

        }

        @Override
        public void onUsernameConflict() {

        }

        @Override
        public void onEmailConflict() {

        }

        @Override
        public void onGeneralGroupError() {

        }

        @Override
        public void onGroupNotFound() {

        }

        @Override
        public void onGroupNameConflict() {

        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_signup);
        usernameET = findViewById(R.id.editText_username);
        emailET = findViewById(R.id.editText_email);
        passwordET = findViewById(R.id.editText_password);
        textView = findViewById(R.id.textView);
        button_signup = (Button) findViewById(R.id.button_signup);
        button_signup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
               // signUp(); //parameter: JSONObject,
                if(usernameET.getText().toString().length() >= 4 || passwordET.getText().toString().length() >= 8) {
                    username = usernameET.getText().toString();
                    email = emailET.getText().toString();
                    password = passwordET.getText().toString();
                    //  RequestBodies.Register user = new RequestBodies.Register(username, password, email);
                    textView.append("username: " + username + "\n email: " + email + "\n password: " + password);
                    // textView.append(REQUESTS.ERRORS.TIME.value());
                    HashMap<String, Object> requestBody = new HashMap<>();

                    requestBody.put("username", username);
                    requestBody.put("password", password);
                    requestBody.put("emailAddress", email);

                    CustomResponseHandler responseHandler = new CustomResponseHandler() {

                        @Override
                        public void onResponse(HashMap<String, Object> response) {
                            textView.append("\n errorCode: " + response.get("errorCode"));
                            Log.e("hey", "got here");
                        }

                        @Override
                        public void onResponse1(Object response) {

                        }

                        @Override
                        public void onFailure() {
                            textView.append("\n your signup was successful");
                            switchToLoginActivity();
                        }

                        @Override
                        public void onErrorResponse(HashMap<String, Object> errorResponse) {
                            textView.append("\n errorCode: " + errorResponse.get("errorCode"));
                            Log.e("hey", "got here");
                        }
                    };
                    MiddleMan sendRegisterRequest = new MiddleMan(getBaseContext(),"register", requestBody, responseHandler);
                    sendRegisterRequest.sendRequest();
                }else{

                }
            }
        });
        toLoginActivity = findViewById(R.id.toLoginActivity);
        toLoginActivity.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view) {
                switchToLoginActivity();
            }
        });
    }

    private void switchToLoginActivity(){
        Intent i = new Intent(this, LoginActivity.class);
        startActivity(i);
    }
}

