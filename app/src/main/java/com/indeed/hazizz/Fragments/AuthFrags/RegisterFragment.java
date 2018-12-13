package com.indeed.hazizz.Fragments.AuthFrags;

import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v7.widget.Toolbar;
import android.text.method.LinkMovementMethod;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;

import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Converter.Converter;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.util.HashMap;
import java.util.regex.Pattern;

import okhttp3.Headers;
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
        public void onResponse(HashMap<String, Object> response) {}
        @Override
        public void onPOJOResponse(Object response) {}
        @Override
        public void onFailure(Call<ResponseBody> call, Throwable t) {
            button_signup.setEnabled(true);
            textView_error.setText("Szerver nem válaszol");

        }
        @Override
        public void onErrorResponse(POJOerror error) {
            int errorCode = error.getErrorCode();
            if(errorCode == 31){

            }if(errorCode == 2){ // rossz adat
                textView_error.setText("A megadott adatok nem megfelelőek");

            }if(errorCode == 32){ // létezik ilyen nevű
              //  textView_error.setText("A felhasználónév már foglalt");
                textView_error.setText("A felhasználónév már foglalt");

            }if(errorCode == 33){ // létezik ilyen nevű
                textView_error.setText("Az email címmel már regisztráltak");
            }if(errorCode == 34){
                textView_error.setText("A regisztráció zárolva van");
            }
            button_signup.setEnabled(true);
        }
        @Override
        public void onEmptyResponse() { }
        @Override
        public void onSuccessfulResponse() {
            Transactor.fragmentLogin(getFragmentManager().beginTransaction());
        }

        @Override
        public void onNoConnection() {
            textView_error.setText("Nincs internet kapcsolat");
            button_signup.setEnabled(true);
        }

        @Override
        public void getHeaders(Headers headers) {

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

    //    textView_termsAndConditions.setText(SafeURLSpan.parseSafeHtml(<<YOUR STRING GOES HERE>>));

        textView_termsAndConditions.setMovementMethod(LinkMovementMethod.getInstance());

        textView_error = v.findViewById(R.id.textView_error);
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
                    textView_error.setText("Csak számokat, betűket, alsóvonalat és kötőjelet tartalmazhat a felhasználónév");
                    return;
                }if (!emailRegex.matcher(email).matches()){
                    textView_error.setText("Az email helytelen");
                }
                else {
                    if (password.length() < 8) {
                        textView_error.setText("A jelszónak legalább 8 karakteresnek kell lennie");
                    } else if (username.length() < 4) {
                        textView_error.setText("A felhasználónévnek legalább 4 karakteresnek kell lennie");
                    } else if (!(password.equals(editText_passwordCheck.getText().toString()))) {
                        textView_error.setText("Jelszó nem egyezik");

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
                            textView_error.setText("Nem fogadtad el az általános felhasználó szerződést");

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
