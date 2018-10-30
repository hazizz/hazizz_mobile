package com.indeed.hazizz.Fragments;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Spinner;
import android.widget.TextView;

import com.indeed.hazizz.Activities.MainActivity;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.POJO.Response.POJOsubject;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgetTaskDetailed;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class ViewTaskFragment extends Fragment implements AdapterView.OnItemSelectedListener{

    private int groupId;
    private int taskId;
    private String groupName;

    private Spinner subject_spinner;

    private TextView type;
    private TextView title;
    private TextView description;
    private TextView creatorName;
    private TextView subject;
    private TextView group;
    private TextView deadLine;

    private List<POJOsubject> subjects = new ArrayList<>();

    private CustomResponseHandler rh;

    private ArrayList<POJOsubject> subjectList = new ArrayList<POJOsubject>();

    private boolean goBackToMain;

    private View v;

    public ViewTaskFragment(){
    }

    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_viewtask, container, false);
        Log.e("hey", "im here lol");
        ((MainActivity)getActivity()).onFragmentCreated();
        type = v.findViewById(R.id.textView_tasktype);
        title = v.findViewById(R.id.textView_title);
        description = v.findViewById(R.id.editText_description);
        creatorName = v.findViewById(R.id.textView_creator);
        subject = v.findViewById(R.id.textView_subject);
        group = v.findViewById(R.id.textView_group);
        deadLine = v.findViewById(R.id.textview_deadline);


        Bundle bundle = this.getArguments();
        if (bundle != null) {
            taskId =  bundle.getInt("taskId");
            groupId = bundle.getInt("groupId");
            groupName = bundle.getString("groupName");
            goBackToMain = bundle.getBoolean("goBackToMain");

            Log.e("hey", "got IDs");
            Log.e("hey", taskId + ", " + groupId);
        }else{Log.e("hey", "bundle is null");}
        rh = new CustomResponseHandler() {
            @Override
            public void onResponse(HashMap<String, Object> response) {
                Log.e("hey", "got regular response");

            }

            @Override
            public void onPOJOResponse(Object response) {
                type.setText(((POJOgetTaskDetailed)response).getType());
                title.setText("Cím: " + ((POJOgetTaskDetailed)response).getTitle());
                description.setText(((POJOgetTaskDetailed)response).getDescription());
                creatorName.setText(((POJOgetTaskDetailed)response).getCreator().getUsername());
              //  subject.setText(((POJOgetTaskDetailed)response).getSubjectData().getName());
                subject.setText(((POJOgetTaskDetailed)response).getSubjectData().getName());
                group.setText(((POJOgetTaskDetailed)response).getGroup().getName());

                deadLine.setText(((POJOgetTaskDetailed)response).getDueDate().get(0) + "." +
                        ((POJOgetTaskDetailed)response).getDueDate().get(1) + "." +
                        ((POJOgetTaskDetailed)response).getDueDate().get(2));
            }

            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                Log.e("hey", "4");
                Log.e("hey", "got here onFailure");
                Log.e("hey", "task created");
            }

            @Override
            public void onErrorResponse(POJOerror error) {
                Log.e("hey", "onErrorResponse");
            }

            @Override
            public void onEmptyResponse() { }
            @Override
            public void onSuccessfulResponse() { }

            @Override
            public void onNoConnection() {
            //    textView_noContent.setText("Nincs internet kapcsolat");

            }
        };
        HashMap<String, Object> vars = new HashMap<>();
        vars.put("taskId", taskId);
        vars.put("groupId", groupId);
        MiddleMan.newRequest(this.getActivity(), "getTask", null, rh, vars);

        return v;
    }

    @Override
    public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
    }

    @Override
    public void onNothingSelected(AdapterView<?> adapterView) {
    }

    public void toCreateTask(){
        Log.e("hey", "toCreateTask in viewtaskFrag" + groupId);
        Transactor.fragmentGroups(getFragmentManager().beginTransaction(), true);
    }
  /*  public void toCreateTask(){
        Transactor.fragmentCreateTask(getFragmentManager().beginTransaction(),groupID, groupName);
        Log.e("hey", "called 123");
    } */

    public int getGroupId(){
        return groupId;
    }
    public String getGroupName(){
        return groupName;
    }
    public boolean getGoBackToMain(){
        return goBackToMain;
    }
}
