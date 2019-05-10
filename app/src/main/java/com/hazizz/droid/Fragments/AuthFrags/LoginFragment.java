package com.hazizz.droid.fragments.AuthFrags;

import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;

import com.hazizz.droid.activities.AuthActivity;

import com.hazizz.droid.communication.requests.RequestType.Login;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoAuth;
import com.hazizz.droid.communication.responsePojos.PojoError;
import com.hazizz.droid.converter.Converter;
import com.hazizz.droid.other.AppInfo;
import com.hazizz.droid.other.SharedPrefs;
import com.hazizz.droid.navigation.Transactor;
import com.hazizz.droid.communication.MiddleMan;
import com.hazizz.droid.R;

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
    private TextView button_register;

    private View v;

    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        v = inflater.inflate(R.layout.fragment_login, container, false);
        editText_username = v.findViewById(R.id.editText_username);
        editText_password = v.findViewById(R.id.editText_password);
        checkBox_autoLogin = v.findViewById(R.id.checkBox_autoLogin);
        button_register = v.findViewById(R.id.button_register);
        button_register.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view) {
                Transactor.fragmentRegister(getFragmentManager().beginTransaction());
            }
        });

        textView_error = (TextView) v.findViewById(R.id.textView_error_currentPassword);
        textView_error.setTextColor(Color.rgb(255, 0, 0));

        button_login = (Button) v.findViewById(R.id.button_login);

        button_login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(editText_password.getText().toString().length() < 8) {
                    textView_error.setText(R.string.error_passwordNotLongEnough);
                }else if(editText_username.getText().toString().length() < 4) {
                    textView_error.setText(R.string.error_usernameLength);
                }
                else{
                    username = editText_username.getText().toString();
                    password = editText_password.getText().toString();
                    password = Converter.hashString(password);

                    button_login.setEnabled(false);
                    MiddleMan.newRequest(new Login(getActivity(), new CustomResponseHandler() {
                        @Override
                        public void onPOJOResponse(Object response) {
                            if(checkBox_autoLogin.isChecked()){
                                AppInfo.setAutoLogin(getContext(), true);
                            }
                            AppInfo.setLoggedIn(getContext(), true);
                            SharedPrefs.TokenManager.setToken(getContext() ,((PojoAuth)response).getToken());
                            SharedPrefs.TokenManager.setRefreshToken(getContext() ,((PojoAuth)response).getRefresh());
                            button_login.setEnabled(true);
                            ((AuthActivity)getActivity()).openMainActivity();
                            Transactor.fragmentFirst(getFragmentManager().beginTransaction());
                        }
                        @Override
                        public void onFailure(Call<ResponseBody> call, Throwable t) {
                            button_login.setEnabled(true);
                            textView_error.setText(R.string.info_serverNotResponding);
                        }
                        @Override
                        public void onNoConnection() {
                            textView_error.setText(R.string.info_noInternetAccess);
                            button_login.setEnabled(true);
                        }
                        @Override
                        public void onErrorResponse(PojoError error) {
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
                            button_login.setEnabled(true);
                        }
                    }, username, password));
                }
            }
        });
        return v;
    }
}