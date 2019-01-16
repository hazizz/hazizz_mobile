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
import android.widget.RadioGroup;
import android.widget.TextView;

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
import java.util.EnumMap;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class JoinGroupFragment extends Fragment {

    private View v;

    private EditText editText_joinGroup;
    private EditText editText_password;
    private Button button_joinGroup;
    private TextView textView_error;
    private RadioButton radioButton_open;
    private RadioButton radioButton_invite_only;
    private RadioButton radioButton_password;
    private RadioGroup radioGroup_groupTypes;

    private String groupName;
    private String password;
    private int groupId;

    CustomResponseHandler rh_joinGroup = new CustomResponseHandler() {
        @Override
        public void onFailure(Call<ResponseBody> call, Throwable t) {
            textView_error.setText(R.string.info_noInternetAccess);
            button_joinGroup.setEnabled(true);
            editText_joinGroup.setEnabled(true);
            editText_password.setEnabled(true);
            radioGroup_groupTypes.setEnabled(true);
        }
        @Override
        public void onErrorResponse(POJOerror error) {
            if(error.getErrorCode() == 55){ // user already in group
                textView_error.setText(R.string.error_alreadyMemberOfGroup);
            }else if(error.getErrorCode() == 56){
                textView_error.setText(R.string.error_wrongPassword);
            }
            button_joinGroup.setEnabled(true);
            editText_joinGroup.setEnabled(true);
            editText_password.setEnabled(true);
            radioGroup_groupTypes.setEnabled(true);
        }
        @Override
        public void onSuccessfulResponse() {
            Transactor.fragmentMainGroup(getFragmentManager().beginTransaction(), groupId, groupName);
            AndroidThings.closeKeyboard(getContext(), v);
        }
        @Override
        public void onNoConnection() {
            textView_error.setText(R.string.info_noInternetAccess);
            button_joinGroup.setEnabled(true);
            editText_joinGroup.setEnabled(true);
            editText_password.setEnabled(true);
            radioGroup_groupTypes.setEnabled(true);
        }
    };

    CustomResponseHandler rh_getGroups = new CustomResponseHandler() {
        @Override
        public void onPOJOResponse(Object response) {
            boolean found = false;
            ArrayList<POJOgroup> castedList = (ArrayList<POJOgroup>) response;
            for(POJOgroup g : castedList){
                if(g.getName().equals(groupName)) {
                    found = true;
                    if (g.getGroupType().equals(Strings.Path.GROUPTYPE_OPEN.toString())) {
                        groupId = g.getId();
                        EnumMap<Strings.Path, Object> vars = new EnumMap<>(Strings.Path.class);
                        vars.put(Strings.Path.GROUPID, Integer.toString(groupId));
                        MiddleMan.newRequest(getActivity(),"joinGroup", null, rh_joinGroup, vars);
                    }
                    else if (g.getGroupType().equals(Strings.Path.GROUPTYPE_PASSWORD.toString())) {
                        if(password != null) {
                            groupId = g.getId();
                            EnumMap<Strings.Path, Object> vars = new EnumMap<>(Strings.Path.class);
                            vars.put(Strings.Path.GROUPID, Integer.toString(groupId));
                            vars.put(Strings.Path.PASSWORD, password);
                            MiddleMan.newRequest(getActivity(), "joinGroupByPassword", null, rh_joinGroup, vars);

                        }else{
                            editText_password.getLayoutParams().height = ViewGroup.LayoutParams.WRAP_CONTENT;
                            textView_error.setText(getString(R.string.error_passwordRequiredForGroup));
                        }
                    } else {
                        textView_error.setText(R.string.error_noPermissionToJoinGroup);
                        button_joinGroup.setEnabled(true);
                        editText_password.setEnabled(true);
                        editText_joinGroup.setEnabled(true);
                        radioGroup_groupTypes.setEnabled(true);
                    }
                    break;
                }
            }
            if(!found){
                textView_error.setText(R.string.error_noSuchGroup);
                button_joinGroup.setEnabled(true);
                editText_joinGroup.setEnabled(true);
                editText_password.setEnabled(true);
                radioGroup_groupTypes.setEnabled(true);
            }
        }
        @Override
        public void onFailure(Call<ResponseBody> call, Throwable t) {
            Log.e("hey", "4");
            Log.e("hey", "got here onFailure");
            textView_error.setText(R.string.info_noInternetAccess);
            button_joinGroup.setEnabled(true);
            editText_joinGroup.setEnabled(true);
            editText_password.setEnabled(true);
            radioGroup_groupTypes.setEnabled(true);

        }

        @Override
        public void onErrorResponse(POJOerror error) {
            button_joinGroup.setEnabled(true);
            editText_joinGroup.setEnabled(true);
            editText_password.setEnabled(true);
            radioGroup_groupTypes.setEnabled(true);

        }

        @Override
        public void onNoConnection() {
            textView_error.setText(R.string.info_noInternetAccess);
            button_joinGroup.setEnabled(true);
            editText_joinGroup.setEnabled(true);
            editText_password.setEnabled(true);
            radioGroup_groupTypes.setEnabled(true);
        }
    };

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_joingroup, container, false);
        ((MainActivity)getActivity()).onFragmentCreated();

        textView_error = v.findViewById(R.id.textView_error_currentPassword);
        textView_error.setTextColor(Color.rgb(255, 0, 0));
        editText_joinGroup = v.findViewById(R.id.editText_joinGroup);
        editText_password = v.findViewById(R.id.editText_password);

        radioGroup_groupTypes = v.findViewById(R.id.radioGroup);
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

        button_joinGroup = v.findViewById(R.id.button_joinGroup);
        button_joinGroup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                button_joinGroup.setEnabled(false);

                if(radioButton_open.isChecked()){
                    radioGroup_groupTypes.setEnabled(false);
                }else if(radioButton_invite_only.isChecked()){

                }else if(radioButton_password.isChecked()){
                    password = editText_password.getText().toString();
                    if(password.isEmpty()){
                        textView_error.setText(getString(R.string.empty_field_password));
                        button_joinGroup.setEnabled(true);
                        password = null;
                        return;
                    }
                    radioGroup_groupTypes.setEnabled(false);
                }

                groupName = editText_joinGroup.getText().toString();
                editText_joinGroup.setEnabled(false);
                editText_password.setEnabled(false);
                MiddleMan.newRequest(getActivity(),"getGroups", null, rh_getGroups, null);
            }
        });
        return v;
    }
}
