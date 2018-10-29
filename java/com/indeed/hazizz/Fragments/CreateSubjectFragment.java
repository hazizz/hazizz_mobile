package com.indeed.hazizz.Fragments;

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

import com.indeed.hazizz.Activities.MainActivity;
import com.indeed.hazizz.AndroidThings;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Listviews.GroupList.CustomAdapter;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.util.HashMap;

public class CreateSubjectFragment extends Fragment {

    private View v;
    private CustomAdapter adapter;
    private EditText editText_newSubject;
    private Button button_addSubject;
    private TextView textView_error;

    private int groupId;
    private String groupName;

    private boolean destCreateTask = false;

    CustomResponseHandler rh = new CustomResponseHandler() {

        @Override
        public void onResponse(HashMap<String, Object> response) {

        }

        @Override
        public void onPOJOResponse(Object response) {
        }
        @Override
        public void onFailure() {
            Log.e("hey", "4");
            Log.e("hey", "got here onFailure");
            button_addSubject.setEnabled(true);
        }


        @Override
        public void onEmptyResponse() {

        }

        @Override
        public void onSuccessfulResponse() {

            AndroidThings.closeKeyboard(getContext(), v);
            goBack();
        }

        @Override
        public void onNoConnection() {
            textView_error.setText("Nincs internet kapcsolat");
            button_addSubject.setEnabled(true);
        }

        @Override
        public void onErrorResponse(POJOerror error) {
            //  textView.append("\n errorCode: " + error.getErrorCode());
            if(error.getErrorCode() == 2){ // validation failed
              //  textView_error.setText("Helytelen jelszó");
            }
            if(error.getErrorCode() == 31){ // no such user
              //  textView_error.setText("Felhasználó nem található");
            }
            Log.e("hey", "errodCOde is " + error.getErrorCode() + "");
            Log.e("hey", "got here onErrorResponse");
            button_addSubject.setEnabled(true);
        }
    };


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_addsubject, container, false);
        ((MainActivity)getActivity()).onFragmentCreated();
        groupId = getArguments().getInt("groupId");
        groupName = getArguments().getString("groupName");

        textView_error = v.findViewById(R.id.textView_error);
        editText_newSubject = v.findViewById(R.id.editText_newSubject);
        button_addSubject = v.findViewById(R.id.button_addSubject);


        button_addSubject.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(editText_newSubject.getTextSize() != 0) {
                    HashMap<String, Object> body = new HashMap<>();
                    body.put("name", editText_newSubject.getText().toString());
                    HashMap<String, Object> vars = new HashMap<>();
                    vars.put("groupId", groupId);                    button_addSubject.setEnabled(false);

                    MiddleMan.newRequest(getActivity(), "createSubject", body, rh, vars);
                }else{
                    // TODO subject name not long enough
                    Log.e("hey", "else 123");
                }
            }
        });
        return v;
    }

    public void goBack(){
        Transactor.fragmentCreateTask(getFragmentManager().beginTransaction(), groupId, groupName);
    }
}
