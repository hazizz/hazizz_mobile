package com.indeed.hazizz.Fragments;

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
import android.widget.EditText;
import android.widget.TextView;

import com.crashlytics.android.answers.Answers;
import com.crashlytics.android.answers.CustomEvent;
import com.indeed.hazizz.Activities.MainActivity;
import com.indeed.hazizz.AndroidThings;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.Strings;
import com.indeed.hazizz.Fragments.GroupTabs.GroupTabFragment;
import com.indeed.hazizz.Listviews.GroupList.CustomAdapter;
import com.indeed.hazizz.Manager;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.util.EnumMap;
import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Call;


public class CreateSubjectFragment extends Fragment {

    private View v;
    private CustomAdapter adapter;
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
        public void onErrorResponse(POJOerror error) {
            if(error.getErrorCode() == 2){ // validation failed

            }
            if(error.getErrorCode() == 31){ // no such user
              //  textView_error.setText("Felhasználó nem található");
            }
            Log.e("hey", "errodCOde is " + error.getErrorCode() + "");
            Log.e("hey", "got here onErrorResponse");
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
        ((MainActivity)getActivity()).onFragmentCreated();
        groupId = getArguments().getInt("groupId");
        groupName = getArguments().getString("groupName");

        textView_error = v.findViewById(R.id.textView_error_currentPassword);
        textView_error.setTextColor(Color.rgb(255, 0, 0));
        editText_newSubject = v.findViewById(R.id.editText_newSubject);
        button_addSubject = v.findViewById(R.id.button_addSubject);

        button_addSubject.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String subjectName = editText_newSubject.getText().toString().trim();
                if(subjectName.length() >= 2 && subjectName.length() <= 20) {
                    HashMap<String, Object> body = new HashMap<>();
                    body.put("name", subjectName);
                    EnumMap<Strings.Path, Object> vars = new EnumMap<>(Strings.Path.class);
                    vars.put(Strings.Path.GROUPID, Integer.toString(groupId));
                    button_addSubject.setEnabled(false);

                    MiddleMan.newRequest(getActivity(),"createSubject", body, rh, vars);
                }else{
                    textView_error.setText(R.string.error_subjectLength);
                }
            }
        });
        return v;
    }

    public void goBack(){
        if(Manager.DestManager.getDest() == Manager.DestManager.TOCREATETASK) {
            Transactor.fragmentCreateTask(getFragmentManager().beginTransaction(), GroupTabFragment.groupId, GroupTabFragment.groupName, Manager.DestManager.TOGROUP);
        }else if(Manager.DestManager.getDest() == Manager.DestManager.TOSUBJECTS){
            Transactor.fragmentSubjects(getFragmentManager().beginTransaction(), GroupTabFragment.groupId, GroupTabFragment.groupName);
        }else{
            Transactor.fragmentSubjects(getFragmentManager().beginTransaction(), GroupTabFragment.groupId, GroupTabFragment.groupName);
        }
    }
}
