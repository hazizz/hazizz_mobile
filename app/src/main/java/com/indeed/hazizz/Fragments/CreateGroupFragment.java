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
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.RadioButton;

import android.widget.TextView;

import com.crashlytics.android.answers.Answers;
import com.crashlytics.android.answers.CustomEvent;
import com.indeed.hazizz.Activities.MainActivity;
import com.indeed.hazizz.AndroidThings;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.POJO.Response.POJOgroup;
import com.indeed.hazizz.Communication.Strings;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.util.ArrayList;
import java.util.HashMap;

import okhttp3.Headers;
import okhttp3.ResponseBody;
import retrofit2.Call;

public class CreateGroupFragment extends Fragment {

    private View v;
    private EditText editText_createGroup;
    private EditText editText_password;
    private Button button_createGroup;
    private TextView textView_error;
    private RadioButton radioButton_open;
    private RadioButton radioButton_invite_only;
    private RadioButton radioButton_password;

    private int groupId;
    private String groupName;
    private String newGroupName;

    CustomResponseHandler rh_getGroups = new CustomResponseHandler() {
        @Override
        public void onPOJOResponse(Object response) {
            ArrayList<POJOgroup> castedList = (ArrayList<POJOgroup>) response;
            for(POJOgroup g : castedList){
                if(newGroupName.equals(g.getName())){
                    Transactor.fragmentMainGroup(getFragmentManager().beginTransaction(), g.getId(), newGroupName);
                    AndroidThings.closeKeyboard(getContext(), v);
                    break;
                }
            }
        }
        @Override
        public void onFailure(Call<ResponseBody> call, Throwable t) {
            textView_error.setText(R.string.info_noInternetAccess);
        }
        @Override
        public void onErrorResponse(POJOerror error) {
            if(error.getErrorCode() == 2){ // validation failed
                textView_error.setText(R.string.error_groupNameNotAcceptable);
            }
            else if(error.getErrorCode() == 31){ // no such user
                //  textView_error.setText("Felhasználó nem található");
            }

            else if(error.getErrorCode() == 52){ // group already exists
                textView_error.setText(R.string.error_groupAlreadyExists);
            }
            button_createGroup.setEnabled(true);
        }
    };

    CustomResponseHandler rh = new CustomResponseHandler() {
        @Override
        public void onFailure(Call<ResponseBody> call, Throwable t) {
            button_createGroup.setEnabled(true);
        }
        @Override
        public void onNoConnection() {
            textView_error.setText(R.string.info_noInternetAccess);
            button_createGroup.setEnabled(true);
        }

        @Override
        public void getHeaders(Headers headers) {
            int groupId = Integer.parseInt(headers.get("Location").split("groups/")[1]);
            Transactor.fragmentMainGroup(getFragmentManager().beginTransaction(), groupId, newGroupName);
            Answers.getInstance().logCustom(new CustomEvent("create group")
                    .putCustomAttribute("status", "success")
            );
        }

        @Override
        public void onErrorResponse(POJOerror error) {
            if(error.getErrorCode() == 2){ // validation failed
                  textView_error.setText(R.string.error_groupNameNotAcceptable);
            }
            else if(error.getErrorCode() == 31){ // no such user
            }

            else if(error.getErrorCode() == 52){ // group already exists
                  textView_error.setText(R.string.error_groupAlreadyExists);
            }
            button_createGroup.setEnabled(true);
            Answers.getInstance().logCustom(new CustomEvent("create group")
                    .putCustomAttribute("status", error.getErrorCode())
            );
        }
    };

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_creategroup, container, false);

        ((MainActivity)getActivity()).onFragmentCreated();

        textView_error = v.findViewById(R.id.textView_error_currentPassword);
        textView_error.setTextColor(Color.rgb(255, 0, 0));

        editText_createGroup = v.findViewById(R.id.editText_createGroup);
        editText_password = v.findViewById(R.id.editText_password);
        button_createGroup = v.findViewById(R.id.button_createGroup);

        radioButton_open = v.findViewById(R.id.radioButton_open);
        radioButton_invite_only = v.findViewById(R.id.radioButton_invite_only);
        radioButton_password = v.findViewById(R.id.radioButton_password);

        radioButton_password.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if(isChecked){
                    editText_password.getLayoutParams().height = ViewGroup.LayoutParams.WRAP_CONTENT;
                }else{
                    editText_password.getLayoutParams().height = 1;
                    textView_error.setText("");

                }
                editText_password.requestLayout();
            }
        });

        button_createGroup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                button_createGroup.setEnabled(false);
                if(button_createGroup.getTextSize() != 0) {
                    newGroupName = editText_createGroup.getText().toString().toLowerCase();
                    HashMap<String, Object> body = new HashMap<>();
                    body.put("groupName", newGroupName);

                    String groupType = Strings.Path.GROUPTYPE_OPEN.toString();
                    if(radioButton_open.isChecked()){
                        groupType = Strings.Path.GROUPTYPE_OPEN.toString();
                    }else if(radioButton_invite_only.isChecked()){
                        groupType = Strings.Path.GROUPTYPE_INVITE_ONLY.toString();
                    }else if(radioButton_password.isChecked()){
                        String password = editText_password.getText().toString();
                        if(password.isEmpty()){
                            textView_error.setText(getString(R.string.empty_field_password));
                            button_createGroup.setEnabled(true);
                            return;
                        }
                        groupType = Strings.Path.GROUPTYPE_PASSWORD.toString();
                        body.put("password", password);
                    }
                    body.put("type", groupType);
                    MiddleMan.newRequest(getActivity(),"createGroup", body, rh, null);
                }else{
                    // TODO subject name not long enough
                    Log.e("hey", "else 123");
                }
            }
        });
        return v;
    }
}
