package com.indeed.hazizz.Activities;

import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOauth;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.R;
import com.indeed.hazizz.SharedPrefs;

import android.content.Intent;
import android.graphics.Color;
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
    private TextView textView_error;
 //   private TextView textView;

  //  private MyCallback<ResponseBodies.Error> errorCallback;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        usernameET = findViewById(R.id.editText_username);
        passwordET = findViewById(R.id.editText_password);
        checkBox_autoLogin = findViewById(R.id.checkBox_autoLogin);

        textView_error = (TextView) findViewById(R.id.textView_error);
        textView_error.setTextColor(Color.rgb(255, 0, 0));

        button_login = (Button) findViewById(R.id.button_login);

        button_login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(usernameET.getText().toString().length() >= 4 || passwordET.getText().toString().length() >= 8) {
                    username = usernameET.getText().toString();
                    password = passwordET.getText().toString();
                    HashMap<String, Object> requestBody = new HashMap<>();

                    requestBody.put("username", username);
                    requestBody.put("password", password);

                    CustomResponseHandler responseHandler = new CustomResponseHandler() {

                        @Override
                        public void onResponse(HashMap<String, Object> response) {

                        }

                        @Override
                        public void onPOJOResponse(Object response) {
                            Log.e("hey", "got here onResponse");
                            SharedPrefs.save(getBaseContext(), "token", "token", (String) ((POJOauth)response).getToken());
                            switchToMain();
                            button_login.setEnabled(true);
                        }
                        @Override
                        public void onFailure() {
                            Log.e("hey", "4");
                            Log.e("hey", "got here onFailure");
                        }


                        @Override
                        public void onEmptyResponse() {

                        }

                        @Override
                        public void onSuccessfulResponse() {

                        }

                        @Override
                        public void onErrorResponse(POJOerror error) {
                          //  textView.append("\n errorCode: " + error.getErrorCode());
                            if(error.getErrorCode() == 12){ // wrong password
                                textView_error.setText("Helytelen jelszó");
                            }
                            if(error.getErrorCode() == 31){ // no such user
                                textView_error.setText("Felhasználó nem található");
                            }
                            Log.e("hey", "errodCOde is " + error.getErrorCode() + "");
                            Log.e("hey", "got here onResponse");
                            button_login.setEnabled(true);
                        }
                    };
                    MiddleMan.newRequest(getBaseContext(), "login", requestBody, responseHandler, null);
                }else{
                    //TODO show that the username or password not long enough
                }
                button_login.setEnabled(false);
            }
        });

    }

    private void switchToMain(){
        Intent i = new Intent(this, MainActivity.class);
        startActivity(i);
      //  finish();
    }




}

