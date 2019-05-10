package com.hazizz.droid.fragments.ThéraFrags.Setup;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;



import com.hazizz.droid.communication.requests.RequestType.Thera.PojoSession;
import com.hazizz.droid.communication.requests.RequestType.Thera.ThAuthenticateSession;
import com.hazizz.droid.communication.requests.RequestType.Thera.ThCreateSession.ThCreateSession;
import com.hazizz.droid.communication.requests.RequestType.Thera.ThSchools;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoError;
import com.hazizz.droid.other.CustomSearchableSpinner;
import com.hazizz.droid.communication.MiddleMan;
import com.hazizz.droid.fragments.ParentFragment.ParentFragment;
import com.hazizz.droid.R;
import com.hazizz.droid.other.SharedPrefs;
import com.hazizz.droid.navigation.Transactor;

import java.util.Arrays;
import java.util.HashMap;

public class TheraLoginFragment extends ParentFragment {

    private static final int defaultValue = 0;
    private long authSession = defaultValue;

    private HashMap<String, String> schools;

    private String[] key;
    private String[] value;

    private String chosenSchool;

    private View v;

    private CustomSearchableSpinner spinner_schools;

    private TextView textView_school;

    private EditText editText_username, editText_password;

    private Button button_login;
    private Button button_users;
    private CheckBox checkBox_autoLogin;


    String username;
    String school;
    private int index = -1;


    private CustomResponseHandler rh_getSchools = new CustomResponseHandler() {
        @Override
        public void onPOJOResponse(Object response) {
            schools = (HashMap<String, String>)response;

            Object[] a = schools.keySet().toArray();
            key = Arrays.copyOf(a, a.length, String[].class);

            a = schools.values().toArray();
            value = Arrays.copyOf(a, a.length, String[].class);
            ArrayAdapter adapter=new ArrayAdapter(getContext(), R.layout.support_simple_spinner_dropdown_item, key);
            spinner_schools.setAdapter(adapter);

            if(username != null && school != null){
                editText_username.setText(username);
             //   chosenSchool = school;

                for (int i=0;i<value.length;i++) {
                    if (value[i].equals(school)) {
                        index = i;
                        spinner_schools.setSelection(index);
                        break;
                    }
                }
            }
        }
    };

    private CustomResponseHandler rh_session = new CustomResponseHandler() {
        @Override
        public void onPOJOResponse(Object response) {
            PojoSession session = (PojoSession)response;
            SharedPrefs.ThSessionManager.setSessionId(getContext(), (int) session.getId());
        //    if(checkBox_autoLogin.isChecked()){
                SharedPrefs.ThLoginData.setData(getContext(), session.getId(),editText_username.getText().toString(), chosenSchool);
           // }
            if(session.getStatus() == "ACTIVE"){
                Transactor.fragmentThUsers(getFragmentManager().beginTransaction());
            }
            Transactor.fragmentThUsers(getFragmentManager().beginTransaction());
        }

        @Override
        public void onSuccessfulResponse() {
            Transactor.fragmentThUsers(getFragmentManager().beginTransaction());
        }

        @Override
        public void onErrorResponse(PojoError error) {
            if(error.getErrorCode() == 113){
                // wong user or pass
            }
        }
    };

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_th_login, container, false);
        fragmentSetup(R.string.title_kreta_login);

        editText_username = v.findViewById(R.id.editText_username);
        editText_password = v.findViewById(R.id.editText_password);
        checkBox_autoLogin = v.findViewById(R.id.checkBox_autoLogin);

        spinner_schools = v.findViewById(R.id.SearchableSpinner_schools);
        spinner_schools.setTitle(getString(R.string.select_school));
        spinner_schools.setPositiveButton(getString(R.string.close));


        MiddleMan.newRequest(new ThSchools(getActivity(), rh_getSchools));


        button_users = v.findViewById(R.id.button_users);
        button_users.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) {
                Transactor.fragmentThUsers(getFragmentManager().beginTransaction());
        }});

        button_login = v.findViewById(R.id.button_login);
        button_login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                spinner_schools.setVisibility(View.VISIBLE);
                String username2 = editText_username.getText().toString();
                String password2 = editText_password.getText().toString();

                if(!username2.isEmpty() || !password2.isEmpty()){
                    if(authSession == defaultValue){
                        MiddleMan.newRequest(new ThCreateSession(getActivity(), rh_session, username2, password2, chosenSchool));

                    }else{
                        MiddleMan.newRequest(new ThAuthenticateSession(getActivity(), rh_session, authSession, password2));
                    }
                }

            }
        });
        textView_school = v.findViewById(R.id.textView_school);


        spinner_schools.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                chosenSchool = value[position];

                textView_school.setText(key[position]);



            }
            @Override public void onNothingSelected(AdapterView<?> parent) {
            }
        });




        if(getArguments() != null) {
            authSession = getArguments().getLong("sessionId");
            school = getArguments().getString("school");
            username = getArguments().getString("username");


            /*else {
                Context c = getContext();
                username = SharedPrefs.ThLoginData.getUsername(c, authSession);
                school = SharedPrefs.ThLoginData.getSchool(c, authSession);
            }*/
        }

        return v;
    }
}
