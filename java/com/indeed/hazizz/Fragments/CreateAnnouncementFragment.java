package com.indeed.hazizz.Fragments;

import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.text.InputType;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.indeed.hazizz.Activities.MainActivity;
import com.indeed.hazizz.AndroidThings;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.ErrorHandler;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class CreateAnnouncementFragment extends Fragment{

    private int groupId;
    private String groupName;

    private EditText announcementTitle;
    private EditText description;
    private Button button_send;
    private TextView textView_error;

    private CustomResponseHandler rh_subjects;
    private CustomResponseHandler rh_taskTypes;

    private View v;

    CustomResponseHandler rh = new CustomResponseHandler() {
        @Override
        public void onResponse(HashMap<String, Object> response) {
            Log.e("hey", "got regular response"); }
        @Override
        public void onPOJOResponse(Object response) {
            Log.e("hey", "got POJOresponse");
        }
        @Override
        public void onFailure(Call<ResponseBody> call, Throwable t) {
            Log.e("hey", "4");
            Log.e("hey", "got here onFailure");
            Log.e("hey", "task created");
        }
        @Override
        public void onErrorResponse(POJOerror error) {
            int errorCode = error.getErrorCode();
            if(errorCode == 2){ // cím túl hosszú (2-20 karatket)
                textView_error.setText("A cím nem megfelelő");
            }
            else if(errorCode == 1){
                ErrorHandler.unExpectedResponseDialog(getActivity());
            }
            button_send.setEnabled(true);
        }
        @Override
        public void onEmptyResponse() { }
        @Override
        public void onSuccessfulResponse() {
            toMainGroupFrag();
            button_send.setEnabled(true);
        }
        @Override
        public void onNoConnection() {
            textView_error.setText("Nincs internet kapcsolat");
            button_send.setEnabled(true);
        }
    };

    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_createannouncement, container, false);
        Log.e("hey", "im here lol");
        ((MainActivity)getActivity()).onFragmentCreated();
        groupId = getArguments().getInt("groupId");
        groupName = getArguments().getString("groupName");
        Log.e("hey", "in createtaskFrag construvtor: " + groupId);

        announcementTitle = v.findViewById(R.id.editText_announcementTitle);
        button_send = (Button)v.findViewById(R.id.button_send);
        description = v.findViewById(R.id.editText_description);
        description.setImeOptions(EditorInfo.IME_ACTION_DONE);
        description.setRawInputType(InputType.TYPE_CLASS_TEXT);
        textView_error = v.findViewById(R.id.textView_error);
        textView_error.setTextColor(Color.rgb(255, 0, 0));

        button_send.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (announcementTitle.getText().length() < 2) {
                    textView_error.setText("A cím túl rövid (minimum 2 karakter)");
                } else if (announcementTitle.getText().length() > 20) {
                    textView_error.setText("A cím túl hosszú (maximum 20 karakter)");
                } else {
                    button_send.setEnabled(false);
                    createAnnouncement();
                }

                AndroidThings.closeKeyboard(getContext(), v);
            }
        });

        return v;
    }

    private void createAnnouncement(){
        HashMap<String, Object> requestBody = new HashMap<>();

        requestBody.put("announcementTitle", announcementTitle.getText().toString());
        requestBody.put("description", description.getText().toString());

        HashMap<String, Object> vars = new HashMap<>();
        vars.put("groupId", Integer.toString(groupId));

        MiddleMan.newRequest(this.getActivity(), "createAnnouncement", requestBody, rh, vars);
    }

    void toMainGroupFrag(){
        Transactor.fragmentMainGroup(getFragmentManager().beginTransaction(),groupId, groupName);
    }
    void toCreateSubjectFrag(){
        Transactor.fragmentCreateSubject(getFragmentManager().beginTransaction(), groupId, groupName);
    }
    public int getGroupId(){
        return groupId;
    }
    public String getGroupName(){
        return groupName;
    }


}
