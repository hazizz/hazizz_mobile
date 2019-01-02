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

import com.indeed.hazizz.Activities.MainActivity;
import com.indeed.hazizz.AndroidThings;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.POJO.Response.POJOgroup;
import com.indeed.hazizz.Listviews.GroupList.CustomAdapter;
import com.indeed.hazizz.Listviews.GroupList.GroupItem;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.util.ArrayList;
import java.util.HashMap;

import okhttp3.Headers;
import okhttp3.ResponseBody;
import retrofit2.Call;

public class CreateGroupFragment extends Fragment {

    private View v;
    private CustomAdapter adapter;
    private EditText editText_createGroup;
    private Button button_createGroup;
    private TextView textView_error;

    private int groupId;
    private String groupName;
    private String newGroupName;

    private boolean destTaskEditor = false;

    CustomResponseHandler rh_getGroups = new CustomResponseHandler() {

        @Override
        public void onResponse(HashMap<String, Object> response) { }

        @Override
        public void getHeaders(Headers headers) {

        }

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
        public void onEmptyResponse() { }

        @Override
        public void onSuccessfulResponse() { }

        @Override
        public void onNoConnection() {

        }

        @Override
        public void onErrorResponse(POJOerror error) {
            //  textView.append("\n errorCode: " + error.getErrorCode());
            if(error.getErrorCode() == 2){ // validation failed
                textView_error.setText(R.string.error_groupNameNotAcceptable);
            }
            else if(error.getErrorCode() == 31){ // no such user
                //  textView_error.setText("Felhasználó nem található");
            }

            else if(error.getErrorCode() == 52){ // group already exists
                textView_error.setText(R.string.error_groupAlreadyExists);
            }
            Log.e("hey", "errodCOde is " + error.getErrorCode() + "");
            Log.e("hey", "got here onErrorResponse");
            button_createGroup.setEnabled(true);
        }
    };


    CustomResponseHandler rh = new CustomResponseHandler() {

        @Override
        public void onResponse(HashMap<String, Object> response) { }
        @Override
        public void onPOJOResponse(Object response) { }
        @Override
        public void onFailure(Call<ResponseBody> call, Throwable t) {
            Log.e("hey", "4");
            Log.e("hey", "got here onFailure");
            button_createGroup.setEnabled(true);
        }

        @Override
        public void onEmptyResponse() { }

        @Override
        public void onSuccessfulResponse() {
           // goBack();
        //    MiddleMan.request.getGroupsFromMe(getActivity(), null, rh_getGroups, null);
         //   MiddleMan.newRequest(getActivity(), "getGroupsFromMe", null, rh_getGroups, null);
        }

        @Override
        public void onNoConnection() {
            textView_error.setText(R.string.info_noInternetAccess);
            button_createGroup.setEnabled(true);
        }

        @Override
        public void getHeaders(Headers headers) {
            int groupId = Integer.parseInt(headers.get("Location").split("groups/")[1]);
         //   HashMap<String, Object> vars = new HashMap<>();
          //  vars.put(Strings.Id.GROUP.toString(), groupId);
           // MiddleMan.newRequest(getActivity(), "getGroupsFromMe", null, rh_getGroups, null);
            Transactor.fragmentMainGroup(getFragmentManager().beginTransaction(), groupId, newGroupName);
        }

        @Override
        public void onErrorResponse(POJOerror error) {
            //  textView.append("\n errorCode: " + error.getErrorCode());
            if(error.getErrorCode() == 2){ // validation failed
                  textView_error.setText(R.string.error_groupNameNotAcceptable);
            }
            else if(error.getErrorCode() == 31){ // no such user
                //  textView_error.setText("Felhasználó nem található");
            }

            else if(error.getErrorCode() == 52){ // group already exists
                  textView_error.setText(R.string.error_groupAlreadyExists);
            }
            Log.e("hey", "errodCOde is " + error.getErrorCode() + "");
            Log.e("hey", "got here onErrorResponse");
            button_createGroup.setEnabled(true);
        }
    };


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_creategroup, container, false);

        ((MainActivity)getActivity()).onFragmentCreated();

        textView_error = v.findViewById(R.id.textView_error);
        textView_error.setTextColor(Color.rgb(255, 0, 0));

        editText_createGroup = v.findViewById(R.id.editText_createGroup);
        button_createGroup = v.findViewById(R.id.button_createGroup);

        button_createGroup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(button_createGroup.getTextSize() != 0) {
                    newGroupName = editText_createGroup.getText().toString().toLowerCase();
                    HashMap<String, Object> body = new HashMap<>();
                    body.put("groupName", newGroupName);
                    body.put("type", "OPEN");button_createGroup.setEnabled(false);
                    MiddleMan.newRequest(getActivity(),"createGroup", body, rh, null);

                }else{
                    // TODO subject name not long enough
                    Log.e("hey", "else 123");
                }
            }
        });
        return v;
    }

    public void goBack(){
        Transactor.fragmentGroups(getFragmentManager().beginTransaction());
    }
}
