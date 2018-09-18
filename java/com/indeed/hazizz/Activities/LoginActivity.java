package com.indeed.hazizz.Activities;

import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.MyCallback;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.ResponseBodies;
import com.indeed.hazizz.Communication.ResponseHandler;
import com.indeed.hazizz.R;
import com.indeed.hazizz.SharedPrefs;

import android.content.Intent;
import android.content.SharedPreferences;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.Button;
import android.widget.TextView;

import java.util.HashMap;

public class LoginActivity extends AppCompatActivity {

    private String username;
    private String password;

    private EditText usernameET;
    private EditText passwordET;
    private CheckBox checkBox_autoLogin;
    private Button button_login;
    private TextView textView;

    private MyCallback<ResponseBodies.Error> errorCallback;

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
        setContentView(R.layout.activity_login);
        usernameET = findViewById(R.id.editText_username);
        passwordET = findViewById(R.id.editText_password);
        checkBox_autoLogin = findViewById(R.id.checkBox_autoLogin);
        textView = findViewById(R.id.textView);

        textView.append("hah");

        button_login = (Button) findViewById(R.id.button_login);

        button_login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(usernameET.getText().toString().length() >= 4 || passwordET.getText().toString().length() >= 8) {
                    username = usernameET.getText().toString();
                    password = passwordET.getText().toString();
                    textView.append("username: " + username + "\n password: " + password);
                    HashMap<String, Object> requestBody = new HashMap<>();

                    requestBody.put("username", username);
                    requestBody.put("password", password);

                    CustomResponseHandler responseHandler = new CustomResponseHandler() {

                        @Override
                        public void onResponse(HashMap<String, Object> response) {
                         //   textView.append("\n errorCode: " + response.get("errorCode"));
                            Log.e("hey", "got here onResponse");
                            SharedPrefs.save(getBaseContext(), "token", "token", (String) response.get("token"));
                            textView.append("\n" + SharedPrefs.getString(getBaseContext(), "token", "token"));
                            switchToMain();
                        }

                        @Override
                        public void onResponse1(Object response) {

                        }

                        @Override
                        public void onFailure() {
                            textView.append("\n  no response");
                            Log.e("hey", "4");
                            Log.e("hey", "got here onFailure");
                        }

                        @Override
                        public void onErrorResponse(HashMap<String, Object> errorResponse) {
                            textView.append("\n errorCode: " + errorResponse.get("errorCode"));
                            Log.e("hey", "got here");
                            Log.e("hey", "got here onResponse");
                        }
                    };
                    MiddleMan sendRegisterRequest = new MiddleMan(getBaseContext(), "login", requestBody, responseHandler);
                    sendRegisterRequest.sendRequest();
                }else{
                    //TODO show that the username or password not long enough
                }
            }
        });
    }

    private void switchToMain(){
        Intent i = new Intent(this, MainActivity.class);
      //  i.putExtra("username", username);
        startActivity(i);
    }
}

