package com.hazizz.droid.Fragments;

import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.text.InputType;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.crashlytics.android.answers.Answers;
import com.crashlytics.android.answers.CustomEvent;
import com.hazizz.droid.Activities.MainActivity;
import com.hazizz.droid.AndroidThings;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.Requests.CreateAT;
import com.hazizz.droid.Communication.Requests.EditAT;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Manager;
import com.hazizz.droid.Transactor;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.R;

import java.util.EnumMap;
import java.util.HashMap;

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
    private TextView textView_fragment_title;

    private View v;

    CustomResponseHandler rh = new CustomResponseHandler() {
        @Override
        public void onErrorResponse(POJOerror error) {
            int errorCode = error.getErrorCode();
            if(errorCode == 2){ // cím túl hosszú (2-20 karatket)
                textView_error.setText(R.string.error_titleNotAcceptable);
            }
            button_send.setEnabled(true);
            Answers.getInstance().logCustom(new CustomEvent("create/edit announcement")
                    .putCustomAttribute("status", errorCode)
            );
        }
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
            Answers.getInstance().logCustom(new CustomEvent("create/edit announcement")
                    .putCustomAttribute("status", "success")
            );
        }
        @Override
        public void onNoConnection() {
            textView_error.setText(R.string.info_noInternetAccess);
            button_send.setEnabled(true);
        }
    };

    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_announcementeditor, container, false);
        ((MainActivity)getActivity()).onFragmentCreated();

        editText_announcementTitle = v.findViewById(R.id.editText_announcementTitle);
        button_send = (Button)v.findViewById(R.id.button_send);
        editText_description = v.findViewById(R.id.editText_description);
        editText_description.setImeOptions(EditorInfo.IME_ACTION_DONE);
        editText_description.setRawInputType(InputType.TYPE_CLASS_TEXT);
        textView_error = v.findViewById(R.id.textView_error_currentPassword);
        textView_error.setTextColor(Color.rgb(255, 0, 0));

        textView_fragment_title = v.findViewById(R.id.textView_subject);

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

            getActivity().setTitle(R.string.title_editannouncement);
            editMode = true;
        }else{
            getActivity().setTitle(R.string.title_newannouncement);

            editMode = false;
        }
        return v;
    }

    private void editAnnouncement(){
        String announcementTitle = editText_announcementTitle.getText().toString().trim();
        String description = editText_description.getText().toString();

        MiddleMan.newRequest(new EditAT(getActivity(), rh, Strings.Path.ANNOUNCEMENTS, announcementId,
                announcementTitle, description));
    }

    private void createAnnouncement(){
        HashMap<String, Object> requestBody = new HashMap<>();

        requestBody.put("announcementTitle", editText_announcementTitle.getText().toString().trim());
        requestBody.put("description", editText_description.getText().toString());
        requestBody.put("subjectId", null);

        EnumMap<Strings.Path, Object> vars = new EnumMap<>(Strings.Path.class);
        vars.put(Strings.Path.GROUPID, Integer.toString(groupId));

        MiddleMan.newRequest(new CreateAT(getActivity(), rh, Strings.Path.ANNOUNCEMENTS, Strings.Path.GROUPS, groupId,
                editText_announcementTitle.getText().toString().trim(),editText_description.getText().toString()));
    }
    public int getGroupId(){
        return groupId;
    }
    public String getGroupName(){
        return groupName;
    }


}
