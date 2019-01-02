package com.indeed.hazizz.Fragments.AuthFrags;

import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;

import com.indeed.hazizz.Activities.MainActivity;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOauth;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Converter.Converter;
import com.indeed.hazizz.R;
import com.indeed.hazizz.SharedPrefs;
import com.indeed.hazizz.Transactor;
import com.snatik.storage.Storage;

import java.util.HashMap;

import okhttp3.Headers;
import okhttp3.ResponseBody;
import retrofit2.Call;

public class LoginFragment extends Fragment {

    private String username;
    private String password;

    private EditText editText_username;
    private EditText editText_password;

    private CheckBox checkBox_autoLogin;
    private Button button_login;
    private TextView textView_error;
    private TextView textView_register;


    private View v;
    //   private TextView textView;

    //  private MyCallback<ResponseBodies.Error> errorCallback;

    CustomResponseHandler responseHandler = new CustomResponseHandler() {

        @Override
        public void onResponse(HashMap<String, Object> response) {

        }
        @Override
        public void onPOJOResponse(Object response) {
            Log.e("hey", "got here onResponse");
          //  SharedPrefs.save(getContext(), "token", "token", (String) ((POJOauth)response).getToken());
           // SharedPrefs.save(getContext(), "token", "refreshToken", (String) ((POJOauth)response).getRefresh());
            if(checkBox_autoLogin.isChecked()){
                SharedPrefs.savePref(getContext(), "autoLogin", "autoLogin", true);
            }
            SharedPrefs.TokenManager.setToken(getContext() ,((POJOauth)response).getToken());
            SharedPrefs.TokenManager.setRefreshToken(getContext() ,((POJOauth)response).getRefresh());
            switchToMain();
            button_login.setEnabled(true);
            Transactor.fragmentFirst(getFragmentManager().beginTransaction());

        }
        @Override
        public void onFailure(Call<ResponseBody> call, Throwable t) {
            Log.e("hey", "got here onFailure");
            button_login.setEnabled(true);
            textView_error.setText(R.string.info_serverNotResponding);
        }
        @Override
        public void onEmptyResponse() {
        }
        @Override
        public void onSuccessfulResponse() {
        }

        @Override
        public void onNoConnection() {
            textView_error.setText(R.string.info_noInternetAccess);
            button_login.setEnabled(true);
        }

        @Override
        public void getHeaders(Headers headers) {

        }

        @Override
        public void onErrorResponse(POJOerror error) {
            //  textView.append("\n errorCode: " + error.getErrorCode());
            if(error.getErrorCode() == 12){ // wrong password
                textView_error.setText(R.string.error_wrongPassword);
            }
            if(error.getErrorCode() == 13){ // no such user
                textView_error.setText(R.string.error_accountLocked);
            }
            if(error.getErrorCode() == 14){
                textView_error.setText(R.string.error_accountExpired);
            }
            if(error.getErrorCode() == 15){ // no such user
                textView_error.setText(R.string.error_accountBanned);
            }
            if(error.getErrorCode() == 31){ // no such user
                textView_error.setText(R.string.error_accountNotFound);
            }

            Log.e("hey", "errodCOde is " + error.getErrorCode() + "");
            button_login.setEnabled(true);
        }
    };


    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        v = inflater.inflate(R.layout.fragment_login, container, false);
        editText_username = v.findViewById(R.id.editText_username);
        editText_password = v.findViewById(R.id.editText_password);
        checkBox_autoLogin = v.findViewById(R.id.checkBox_autoLogin);
        textView_register = v.findViewById(R.id.textView_register);
        textView_register.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view) {
                Transactor.fragmentRegister(getFragmentManager().beginTransaction());
            }
        });

        textView_error = (TextView) v.findViewById(R.id.textView_error);
        textView_error.setTextColor(Color.rgb(255, 0, 0));

        button_login = (Button) v.findViewById(R.id.button_login);

        button_login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {


                //   Log.e("hey", "password: " + editText_password.getText().toString() + ", passwordCheck: " + editText_passwordCheck.getText().toString() + " and they equal: " + editText_password.getText().toString().equals(editText_passwordCheck.getText().toString()));
                if(editText_password.getText().toString().length() < 8) {
                    textView_error.setText(R.string.error_passwordNotLongEnough);
                }else if(editText_username.getText().toString().length() < 4) {
                    textView_error.setText(R.string.error_usernameLength);
                }
                else{
                    username = editText_username.getText().toString();
                    password = editText_password.getText().toString();
                    HashMap<String, Object> requestBody = new HashMap<>();

                    requestBody.put("username", username);
                    requestBody.put("password", Converter.hashString(password));

                    button_login.setEnabled(false);
                    MiddleMan.newRequest(getActivity(), "login", requestBody, responseHandler, null);
                }
            }
        });
        return v;
    }

    private void switchToMain(){
        Intent i = new Intent(this.getActivity(), MainActivity.class);
        startActivity(i);
    }

}