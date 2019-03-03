package com.hazizz.droid.Fragments;

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
import com.hazizz.droid.Activities.MainActivity;
import com.hazizz.droid.AndroidThings;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.POJO.Response.POJOgroup;
import com.hazizz.droid.Communication.Requests.CreateGroup;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Fragments.ParentFragment.ParentFragment;
import com.hazizz.droid.Listener.OnBackPressedListener;
import com.hazizz.droid.Transactor;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.R;

import java.util.ArrayList;
import java.util.HashMap;

import okhttp3.Headers;
import okhttp3.ResponseBody;
import retrofit2.Call;

public class CreateGroupFragment extends ParentFragment {

    private EditText editText_createGroup;
    private EditText editText_password;
    private Button button_createGroup;
    private TextView textView_error;
    private RadioButton radioButton_open;
    private RadioButton radioButton_invite_only;
    private RadioButton radioButton_password;

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

        fragmentSetup(R.string.title_fragment_creategroup);
        setOnBackPressedListener(new OnBackPressedListener() {
            @Override
            public void onBackPressed() {
                clearFragment();
                Transactor.fragmentGroups(getFragmentManager().beginTransaction());
            }
        });


      //  ((MainActivity)getActivity()).onFragmentCreated();
     //   getActivity().setTitle(R.string.title_fragment_creategroup);

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
                String password = "";
                if(button_createGroup.getTextSize() != 0) {
                    newGroupName = editText_createGroup.getText().toString().toLowerCase();

                    Strings.GroupType groupType = Strings.GroupType.OPEN;
                    if(radioButton_open.isChecked()){
                        groupType = Strings.GroupType.OPEN;
                    }else if(radioButton_invite_only.isChecked()){
                        groupType = Strings.GroupType.INVITE_ONLY;
                    }else if(radioButton_password.isChecked()){
                        password = editText_password.getText().toString();
                        if(password.isEmpty()){
                            textView_error.setText(getString(R.string.empty_field_password));
                            button_createGroup.setEnabled(true);
                            return;
                        }
                        groupType = Strings.GroupType.PASSWORD;
                    }
                    if(!groupType.equals(Strings.GroupType.PASSWORD)){
                        MiddleMan.newRequest(new CreateGroup(getActivity(),rh, newGroupName, groupType));
                    }else{
                        MiddleMan.newRequest(new CreateGroup(getActivity(),rh, newGroupName, password));
                    }
                }else{
                }
            }
        });
        return v;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        AndroidThings.closeKeyboard(getContext(), v);
        Log.e("hey", "22 Child onDestroy called");
    }




}
