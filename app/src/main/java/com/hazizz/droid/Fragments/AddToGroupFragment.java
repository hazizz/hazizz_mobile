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
import android.widget.EditText;
import android.widget.TextView;

import com.hazizz.droid.Activities.MainActivity;
import com.hazizz.droid.AndroidThings;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Listviews.GroupList.CustomAdapter;
import com.hazizz.droid.Manager;
import com.hazizz.droid.Transactor;
import com.hazizz.droid.R;

import java.util.EnumMap;
import java.util.HashMap;

import okhttp3.Headers;
import okhttp3.ResponseBody;
import retrofit2.Call;

public class AddToGroupFragment extends Fragment {

    private View v;
    private CustomAdapter adapter;
    private EditText editText_memberName;
    private Button button_addMember;
    private TextView editText_infoGroup;
    private TextView textView_error;

    private int groupId;
    private String groupName;

    private boolean destTaskEditor = false;

    CustomResponseHandler rh = new CustomResponseHandler() {



        @Override
        public void onPOJOResponse(Object response) {
        }
        @Override
        public void onFailure(Call<ResponseBody> call, Throwable t) {
            Log.e("hey", "4");
            Log.e("hey", "got here onFailure");
            button_addMember.setEnabled(true);
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
            textView_error.setText(R.string.info_noInternetAccess);
            button_addMember.setEnabled(true);
        }

        @Override
        public void getHeaders(Headers headers) {

        }

        @Override
        public void onErrorResponse(POJOerror error) {
            //  textView.append("\n errorCode: " + error.getErrorCode());
            if(error.getErrorCode() == 2){ // validation failed
                //  textView_error.setText("Helytelen jelszó");
            }
            if(error.getErrorCode() == 31){ // no such user
                textView_error.setText(R.string.error_accountNotFound);
            }
            Log.e("hey", "errodCOde is " + error.getErrorCode() + "");
            Log.e("hey", "got here onErrorResponse");
            button_addMember.setEnabled(true);
        }
    };


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_addtogroup, container, false);
        ((MainActivity)getActivity()).onFragmentCreated();
        groupId = getArguments().getInt("groupId");
        groupName = getArguments().getString("groupName");

        editText_memberName = v.findViewById(R.id.editText_memberName);
        button_addMember = v.findViewById(R.id.button_addMember);
        editText_infoGroup = v.findViewById(R.id.textView_infoGroup);
        editText_infoGroup.append(groupName);
        textView_error = v.findViewById(R.id.textView_error_currentPassword);
        textView_error.setTextColor(Color.rgb(255, 0, 0));


        button_addMember.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(editText_memberName.getTextSize() != 0) {
                    HashMap<String, Object> body = new HashMap<>();
                    body.put("userId", editText_memberName.getText().toString());

                    EnumMap<Strings.Path, Object> vars = new EnumMap<>(Strings.Path.class);
                    vars.put(Strings.Path.GROUPID, groupId);
                    button_addMember.setEnabled(false);

               //     MiddleMan.request.inviteUserToGroup(getContext(), body, rh, vars);
                }else{
                    // TODO subject name not long enough
                    Log.e("hey", "else 123");
                }
            }
        });
        return v;
    }

    public void goBack(){
        Transactor.fragmentCreateTask(getFragmentManager().beginTransaction(), groupId, groupName, Manager.DestManager.TOGROUP);
    }
}
