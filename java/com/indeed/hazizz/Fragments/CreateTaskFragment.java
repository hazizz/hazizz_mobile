package com.indeed.hazizz.Fragments;

import android.app.DatePickerDialog;
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
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;

import com.indeed.hazizz.Activities.MainActivity;
import com.indeed.hazizz.AndroidThings;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.POJO.Response.POJOsubject;
import com.indeed.hazizz.D8;
import com.indeed.hazizz.ErrorHandler;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class CreateTaskFragment extends Fragment implements AdapterView.OnItemSelectedListener{


    private Integer year, month, day;
    private String str_year, str_month, str_day;

    private int groupId;
    private String groupName;

    private Spinner subject_spinner;

    private Spinner taskType;
    private EditText taskTitle;
    private EditText description;
    private Button button_send;
    private Button button_add;
    private TextView textView_group;
    private TextView textView_error;
    private TextView textView_deadline;

    private DatePickerDialog dpd;


    private List<POJOsubject> subjects = new ArrayList<>();

    private CustomResponseHandler rh_subjects;
    private CustomResponseHandler rh_taskTypes;

    private ArrayList<POJOsubject> subjectList = new ArrayList<POJOsubject>();

    private View v;

    public CreateTaskFragment(){
    }

    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_createtask, container, false);
        Log.e("hey", "im here lol");
        ((MainActivity)getActivity()).onFragmentCreated();
        groupId = getArguments().getInt("groupId");
        groupName = getArguments().getString("groupName");
        Log.e("hey", "in createtaskFrag construvtor: " + groupId);

        subject_spinner = (Spinner)v.findViewById(R.id.subject_spinner);

        button_send = (Button)v.findViewById(R.id.button_send1);
        button_add = v.findViewById(R.id.add_button);
        taskType = (Spinner)v.findViewById(R.id.taskType_spinner);
        taskTitle = v.findViewById(R.id.taskTitle);
        description = v.findViewById(R.id.editText_description);
        description.setImeOptions(EditorInfo.IME_ACTION_DONE);
        description.setRawInputType(InputType.TYPE_CLASS_TEXT);
        textView_error = v.findViewById(R.id.textView_error);
        textView_error.setTextColor(Color.rgb(255, 0, 0));

        textView_deadline = v.findViewById(R.id.textView_deadline);

        textView_deadline.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view) {
                dpd.show();
            }
        });

        // tasktype spinner
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(getContext(), R.array.taskTypes, android.R.layout.simple_spinner_item);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        taskType.setAdapter(adapter);

        // subject spinner
        ArrayAdapter<POJOsubject> s_adapter = new ArrayAdapter<POJOsubject>(getContext(), android.R.layout.simple_spinner_item);
        s_adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        subject_spinner.setAdapter(s_adapter);
        s_adapter.notifyDataSetChanged();
        subject_spinner.setOnItemSelectedListener(this);

        button_add.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                toCreateSubjectFrag();
            }
        });

        button_send.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (year != null && month != null && day != null) {
                    if (taskTitle.getText().length() < 2) {
                        textView_error.setText("A cím túl rövid (minimum 2 karakter)");
                    } else if (taskTitle.getText().length() > 20) {
                        textView_error.setText("A cím túl hosszú (maximum 20 karakter)");
                    } else {
                        button_send.setEnabled(false);
                        createTask();
                    }
                }else{
                    textView_error.setText("Nem állítottál be határidőt");
                }
                AndroidThings.closeKeyboard(getContext(), v);
            }
    });
        rh_taskTypes = new CustomResponseHandler() {
            @Override
            public void onResponse(HashMap<String, Object> response) {
                Log.e("hey", "got regular response");

            }

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
                Log.e("hey", error.getMessage());
                int errorCode = error.getErrorCode();
                if(errorCode == 2){ // cím túl hosszú (2-20 karatket)
                    textView_error.setText("A cím nem megfelelő");
                }
                else{
                    ErrorHandler.unExpectedResponseDialog(getContext());
                }
                button_send.setEnabled(true);
            }

            @Override
            public void onEmptyResponse() {
                toMainGroupFrag();
                button_send.setEnabled(true);
            }

            @Override
            public void onSuccessfulResponse() {

            }

            @Override
            public void onNoConnection() {
                textView_error.setText("Nincs internet kapcsolat");
                button_send.setEnabled(true);
            }
        };
        rh_subjects = new CustomResponseHandler() {
            @Override
            public void onResponse(HashMap<String, Object> response) {
                Log.e("hey", "got regular response");
            }

            @Override
            public void onPOJOResponse(Object response) {
                subjects = (ArrayList<POJOsubject>)response;
                for(POJOsubject s : subjects){
                    s_adapter.add(s);
                    s_adapter.notifyDataSetChanged();
                }
            }

            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                Log.e("hey", "4");
                Log.e("hey", "got here onFailure");
                Log.e("hey", "subject fail");
            }

            @Override
            public void onErrorResponse(POJOerror error) {
                Log.e("hey", "onErrorResponse");
            }

            @Override
            public void onEmptyResponse() {
                Log.e("hey", "there is no repsonse");
            }

            @Override
            public void onSuccessfulResponse() {

            }

            @Override
            public void onNoConnection() {
                textView_error.setText("Nincs internet kapcsolat");
                button_send.setEnabled(true);
            }
        };

        dpd = new DatePickerDialog(this.getActivity(), new DatePickerDialog.OnDateSetListener() {
            @Override
            public void onDateSet(DatePicker datePicker, int y, int m, int d) {
                year = y;
                month = m + 1;
                day = d;
                str_year = "" + year;
                if(month < 10) { str_month = "0" + month; }else{ str_month = month + ""; }
                if(day < 10){str_day = "0" + day;}else{str_day = day + "";}
                textView_deadline.setText("Határidő: " +str_year + "." + str_month + "."+ str_day);
            }
        }, Integer.parseInt(D8.getYear()), Integer.parseInt(D8.getMonth()) -2, Integer.parseInt(D8.getDay()));
        dpd.getDatePicker().setMinDate(Calendar.getInstance().getTimeInMillis() - 1000);

        HashMap<String, Object> vars = new HashMap<>();
        vars.put("groupId", groupId);
        MiddleMan.newRequest(this.getActivity(), "getSubjects", null, rh_subjects, vars);

        return v;
    }

    private void createTask(){
        HashMap<String, Object> requestBody = new HashMap<>();

        requestBody.put("taskType", taskType.getSelectedItem().toString());
        requestBody.put("taskTitle", taskTitle.getText().toString());
        requestBody.put("description", description.getText().toString());
        requestBody.put("subjectId", ((POJOsubject) subject_spinner.getSelectedItem()).getId());//((POJOsubject) subject_spinner.getSelectedItem()).getId());
        Log.e("hey", "date: " + year + "-" + month + "-" + day);
        requestBody.put("dueDate", str_year + "-" + str_month + "-" + str_day);

        HashMap<String, Object> vars = new HashMap<>();
        vars.put("id", groupId);

        MiddleMan.newRequest(this.getActivity(), "createTask", requestBody, rh_taskTypes, vars);
        }

    @Override
    public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
    }

    @Override
    public void onNothingSelected(AdapterView<?> adapterView) {
    }

    void toMainGroupFrag(){
        Transactor.fragmentMainGroup(getFragmentManager().beginTransaction(),groupId, groupName);
      //  Transactor.fragmentGroupTab(getFragmentManager().beginTransaction(), groupId, groupName);

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
