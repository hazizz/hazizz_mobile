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
import com.indeed.hazizz.Communication.Strings;
import com.indeed.hazizz.Manager;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.util.EnumMap;
import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class AnnouncementEditorFragment extends Fragment{

    private boolean editMode = false;

    private int announcementId;
    private int groupId;
    private String groupName;
    private String title;
    private String description;

    private EditText editText_announcementTitle;
    private EditText editText_description;
    private Button button_send;
    private TextView textView_error;

    private View v;

    CustomResponseHandler rh = new CustomResponseHandler() {
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
                textView_error.setText(R.string.error_titleNotAcceptable);
            }
            button_send.setEnabled(true);
        }
        @Override
        public void onEmptyResponse() { }
        @Override
        public void onSuccessfulResponse() {
            if(Manager.DestManager.getDest() == Manager.DestManager.TOGROUP){
                Transactor.fragmentGroupAnnouncement(getFragmentManager().beginTransaction(),groupId, groupName);
            }else if(Manager.DestManager.getDest() == Manager.DestManager.TOMAIN){
                Transactor.fragmentMainAnnouncement(getFragmentManager().beginTransaction());
            }else{
                Transactor.fragmentMainAnnouncement(getFragmentManager().beginTransaction());
            }


            button_send.setEnabled(true);
        }
        @Override
        public void onNoConnection() {
            textView_error.setText(R.string.info_noInternetAccess);
            button_send.setEnabled(true);
        }
    };

    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_announcementeditor, container, false);
        Log.e("hey", "im here lol");
        ((MainActivity)getActivity()).onFragmentCreated();




        Log.e("hey", "in TaskEditorFrag construvtor: " + groupId);

        editText_announcementTitle = v.findViewById(R.id.editText_announcementTitle);
        button_send = (Button)v.findViewById(R.id.button_send);
        editText_description = v.findViewById(R.id.editText_description);
        editText_description.setImeOptions(EditorInfo.IME_ACTION_DONE);
        editText_description.setRawInputType(InputType.TYPE_CLASS_TEXT);
        textView_error = v.findViewById(R.id.textView_error);
        textView_error.setTextColor(Color.rgb(255, 0, 0));

        button_send.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String title = editText_announcementTitle.getText().toString();
                if (title.length() < 2 || title.length() > 20) {
                    textView_error.setText(R.string.error_titleLentgh);
                } else {
                    button_send.setEnabled(false);
                    if(editMode) {
                        editAnnouncement();
                    }else{
                        createAnnouncement();
                    }
                }

                AndroidThings.closeKeyboard(getContext(), v);
            }
        });

        groupId = Manager.GroupManager.getGroupId();
        groupName = Manager.GroupManager.getGroupName();
        announcementId = getArguments().getInt("announcementId");

        if(announcementId != 0) {
            title = getArguments().getString("title");
            description = getArguments().getString("description");

            editText_announcementTitle.setText(title);
            editText_description.setText(description);

            editMode = true;
        }else{
            editMode = false;
        }

        return v;
    }

    private void editAnnouncement(){
        HashMap<String, Object> requestBody = new HashMap<>();

        requestBody.put("announcementTitle", editText_announcementTitle.getText().toString().trim());
        requestBody.put("description", editText_description.getText().toString());
        requestBody.put("subjectId", null);

        EnumMap<Strings.Path, Object> vars = new EnumMap<>(Strings.Path.class);
        vars.put(Strings.Path.GROUPID, Integer.toString(groupId));
        vars.put(Strings.Path.ANNOUNCEMENTID, Integer.toString(announcementId));

        MiddleMan.newRequest(this.getActivity(), "editAnnouncement", requestBody, rh, vars);
    }

    private void createAnnouncement(){
        HashMap<String, Object> requestBody = new HashMap<>();

        requestBody.put("announcementTitle", editText_announcementTitle.getText().toString().trim());
        requestBody.put("description", editText_description.getText().toString());
        requestBody.put("subjectId", null);

        EnumMap<Strings.Path, Object> vars = new EnumMap<>(Strings.Path.class);
        vars.put(Strings.Path.GROUPID, Integer.toString(groupId));

        MiddleMan.newRequest(this.getActivity(), "createAnnouncement", requestBody, rh, vars);
    }
    public int getGroupId(){
        return groupId;
    }
    public String getGroupName(){
        return groupName;
    }


}
