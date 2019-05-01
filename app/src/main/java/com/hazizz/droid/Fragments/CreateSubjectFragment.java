package com.hazizz.droid.fragments;

import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.crashlytics.android.answers.Answers;
import com.crashlytics.android.answers.CustomEvent;
import com.hazizz.droid.other.AndroidThings;


import com.hazizz.droid.Communication.requests.CreateSubject;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.Communication.responsePojos.PojoError;
import com.hazizz.droid.fragments.ParentFragment.ParentFragment;
import com.hazizz.droid.listeners.OnBackPressedListener;
import com.hazizz.droid.navigation.Transactor;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.R;

import okhttp3.ResponseBody;
import retrofit2.Call;


public class CreateSubjectFragment extends ParentFragment {

    private EditText editText_newSubject;
    private Button button_addSubject;
    private TextView textView_error;

    private int groupId;
    private String groupName;

    private boolean destTaskEditor = false;

    CustomResponseHandler rh = new CustomResponseHandler() {
        @Override
        public void onFailure(Call<ResponseBody> call, Throwable t) {
            button_addSubject.setEnabled(true);
        }
        @Override
        public void onSuccessfulResponse() {
            AndroidThings.closeKeyboard(getContext(), v);
            goBack();
            Answers.getInstance().logCustom(new CustomEvent("create subject")
                    .putCustomAttribute("status", "success")
            );
        }
        @Override
        public void onNoConnection() {
            textView_error.setText(R.string.info_noInternetAccess);
            button_addSubject.setEnabled(true);
        }
        @Override
        public void onErrorResponse(PojoError error) {
            if(error.getErrorCode() == 2){ // validation failed

            }
            if(error.getErrorCode() == 31){ // no such user
              //  textView_error.setText("Felhasználó nem található");
            }
            button_addSubject.setEnabled(true);
            Answers.getInstance().logCustom(new CustomEvent("create subject")
                    .putCustomAttribute("status", error.getErrorCode())
            );
        }
    };

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_addsubject, container, false);

        fragmentSetup(R.string.add_subject);
        setOnBackPressedListener(new OnBackPressedListener() {
            @Override
            public void onBackPressed() {
                Transactor.fragmentSubjects(getFragmentManager().beginTransaction(), groupId, groupName);
            }
        });


        groupId = getArguments().getInt(Transactor.KEY_GROUPID);
        groupName = getArguments().getString(Transactor.KEY_GROUPNAME);

        textView_error = v.findViewById(R.id.textView_error_currentPassword);
        textView_error.setTextColor(Color.rgb(255, 0, 0));
        editText_newSubject = v.findViewById(R.id.editText_newSubject);
        button_addSubject = v.findViewById(R.id.button_addSubject);

        button_addSubject.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String subjectName = editText_newSubject.getText().toString().trim();
                if(subjectName.length() >= 2 && subjectName.length() <= 20) {

                    button_addSubject.setEnabled(false);

                    MiddleMan.newRequest(new CreateSubject(getActivity(), rh, groupId, subjectName));
                }else{
                    textView_error.setText(R.string.error_subjectLength);
                }
            }
        });
        return v;
    }

    public void goBack(){
         Transactor.fragmentSubjects(getFragmentManager().beginTransaction(), groupId, groupName);

    }
}
