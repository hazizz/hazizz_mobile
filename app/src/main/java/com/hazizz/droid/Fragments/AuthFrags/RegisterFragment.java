package com.hazizz.droid.Fragments.AuthFrags;


import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.text.method.LinkMovementMethod;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;

import com.crashlytics.android.answers.Answers;
import com.crashlytics.android.answers.SignUpEvent;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Converter.Converter;
import com.hazizz.droid.Transactor;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.R;

import java.util.HashMap;
import java.util.regex.Pattern;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class RegisterFragment extends Fragment {
    private String username;
    private String email;
    private String password;

    private EditText editText_username;
    private EditText editText_email;
    private EditText editText_password;
    private EditText editText_passwordCheck;
    private Button button_signup;
    private CheckBox checkBox_termsAndConditions;
    private TextView textView_termsAndConditions;

    private TextView textView_error;

    private TextView textView_toLogin;

    private View v;

    CustomResponseHandler responseHandler = new CustomResponseHandler() {
        @Override
        public void onFailure(Call<ResponseBody> call, Throwable t) {
            button_signup.setEnabled(true);
            textView_error.setText(R.string.info_serverNotResponding);
        }
        @Override
        public void onErrorResponse(POJOerror error) {
            int errorCode = error.getErrorCode();
            if(errorCode == 2){
                Answers.getInstance().logSignUp(new SignUpEvent()
                        .putSuccess(false)
                        .putCustomAttribute("error code", "2")
                );
                textView_error.setText(R.string.error_givenDataWrong);

            }if(errorCode == 32){
                Answers.getInstance().logSignUp(new SignUpEvent()
                        .putSuccess(false)
                        .putCustomAttribute("error code", "32")
                );
                textView_error.setText(R.string.error_usernameTaken);

            }if(errorCode == 33){
                Answers.getInstance().logSignUp(new SignUpEvent()
                        .putSuccess(false)
                        .putCustomAttribute("error code", "33")
                );
                textView_error.setText(R.string.error_emailTaken);
            }if(errorCode == 34){
                Answers.getInstance().logSignUp(new SignUpEvent()
                        .putSuccess(false)
                        .putCustomAttribute("error code", "34")
                );
                textView_error.setText(R.string.error_registrationLocked);
            }
            button_signup.setEnabled(true);
        }
        @Override
        public void onSuccessfulResponse() {
            Answers.getInstance().logSignUp(new SignUpEvent().putSuccess(true).putCustomAttribute("signed up", "true"));
            Transactor.fragmentLogin(getFragmentManager().beginTransaction());
        }
        @Override
        public void onNoConnection() {
            textView_error.setText(R.string.info_noInternetAccess);
            button_signup.setEnabled(true);
        }
    };

    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_register, container, false);
        editText_username = v.findViewById(R.id.editText_username);
        editText_email = v.findViewById(R.id.editText_email);
        editText_password = v.findViewById(R.id.editText_password);
        editText_passwordCheck = v.findViewById(R.id.editText_passwordCheck);
        checkBox_termsAndConditions = v.findViewById(R.id.checkBox_termsAndConditions);
        textView_termsAndConditions = v.findViewById(R.id.textView_termsAndConditions);

        textView_termsAndConditions.setMovementMethod(LinkMovementMethod.getInstance());
        textView_termsAndConditions.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                checkBox_termsAndConditions.setChecked(!checkBox_termsAndConditions.isChecked());
            }
        });
        textView_error = v.findViewById(R.id.textView_error_currentPassword);
        textView_error.setTextColor(Color.rgb(255, 0, 0));

        button_signup = (Button) v.findViewById(R.id.button_signup);
        button_signup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                username = editText_username.getText().toString().trim();
                password = editText_password.getText().toString();
                email = editText_email.getText().toString();
                Pattern emailRegex = Pattern
                        .compile ("[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");

                if(!username.matches("^[a-zA-Z0-9_-]*$")){
                    textView_error.setText(R.string.error_usernameFormat);
                    return;
                }if (!emailRegex.matcher(email).matches()){
                    textView_error.setText(R.string.error_emailWrong);
                }else {
                    if (password.length() < 8) {
                        textView_error.setText(R.string.error_passwordNotLongEnough);
                    } else if (username.length() < 4) {
                        textView_error.setText(R.string.error_usernameLength);
                    } else if (!(password.equals(editText_passwordCheck.getText().toString()))) {
                        textView_error.setText(R.string.error_passwordDoesntMatch);
                    } else {
                        if (checkBox_termsAndConditions.isChecked()) {
                            password = Converter.hashString(editText_password.getText().toString());

                            HashMap<String, Object> requestBody = new HashMap<>();

                            requestBody.put("username", username);
                            requestBody.put("password", password);
                            requestBody.put("emailAddress", email);
                            requestBody.put("consent", true);
                            button_signup.setEnabled(false);

                            MiddleMan.newRequest(getActivity(), "register", requestBody, responseHandler, null);
                        }else {
                            textView_error.setText(R.string.error_termsAndConditionsNotAccepted);
                        }
                    }
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
