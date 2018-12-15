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
import com.indeed.hazizz.Manager;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import okhttp3.Headers;
import okhttp3.ResponseBody;
import retrofit2.Call;

public class TaskEditorFragment extends Fragment implements AdapterView.OnItemSelectedListener{

    private List<String> taskTypeList = Arrays.asList("házi feladat", "teszt");

    private boolean editMode = false;

    private Integer year, month, day;
    private String str_year, str_month, str_day;

    private int groupId;
    private String groupName;
    private int subject;
    private int taskId;

    private Spinner spinner_subject;

    private Spinner spinner_taskType;
    private EditText editText_taskTitle;
    private EditText editText_description;
    private Button button_send;
    private Button button_add;
    private TextView textView_error;
    private TextView textView_deadline;

    private DatePickerDialog dpd;

    private List<POJOsubject> subjects = new ArrayList<>();


    private View v;

    ArrayAdapter<POJOsubject> s_adapter;

    CustomResponseHandler rh_task = new CustomResponseHandler() {
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
            button_send.setEnabled(true);
        }
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
    CustomResponseHandler rh_subjects = new CustomResponseHandler() {
        @Override
        public void onPOJOResponse(Object response) {
            subjects = (ArrayList<POJOsubject>)response;
            s_adapter.clear();
            int emSubjectId = 0;
            for(POJOsubject s : subjects){
                s_adapter.add(s);
                if(subject == s.getId()){
                    emSubjectId = s.getId();
                }
            }
            s_adapter.notifyDataSetChanged();
            if(editMode){
                spinner_subject.setSelection(emSubjectId);
            }
            s_adapter.notifyDataSetChanged();
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
        public void onSuccessfulResponse() {
        }
        @Override
        public void onNoConnection() {
            textView_error.setText("Nincs internet kapcsolat");
            button_send.setEnabled(true);
        }
    };

    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_taskeditor, container, false);
        Log.e("hey", "im here lol");
        ((MainActivity)getActivity()).onFragmentCreated();

        Manager.DestManager.resetDest();




        spinner_subject = (Spinner)v.findViewById(R.id.subject_spinner);

        button_send = (Button)v.findViewById(R.id.button_send);
        button_add = v.findViewById(R.id.add_button);
        spinner_taskType = (Spinner)v.findViewById(R.id.taskType_spinner);
        editText_taskTitle = v.findViewById(R.id.taskTitle);
        editText_description = v.findViewById(R.id.editText_description);
        editText_description.setImeOptions(EditorInfo.IME_ACTION_DONE);
        editText_description.setRawInputType(InputType.TYPE_CLASS_TEXT);
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

    //    ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(getContext(), taskTypeArray, android.R.layout.simple_spinner_item);

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(
                getActivity(),
                android.R.layout.simple_list_item_1,
                taskTypeList );

        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner_taskType.setAdapter(adapter);

        // subject spinner
        s_adapter = new ArrayAdapter<POJOsubject>(getContext(), android.R.layout.simple_spinner_item);
        s_adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner_subject.setAdapter(s_adapter);
        s_adapter.notifyDataSetChanged();
        spinner_subject.setOnItemSelectedListener(this);

        groupId = Manager.GroupManager.getGroupId();
        groupName = Manager.GroupManager.getGroupName();
        taskId = getArguments().getInt("taskId");
        if(taskId != 0) {
            subject = getArguments().getInt("subject");
            int[] date = getArguments().getIntArray("date");
            editText_taskTitle.setText(getArguments().getString("title"));
            editText_description.setText(getArguments().getString("description"));
            String type = getArguments().getString("type");

            if(type == "homework"){
                spinner_taskType.setSelection(1);
            }else{
                spinner_taskType.setSelection(0);
            }

            textView_deadline.setText("Határidő: " + date[0] + "." + date[1] + "." + date[2]);
            str_year = Integer.toString(date[0]);
            str_month = Integer.toString(date[1]);
            str_day = Integer.toString(date[2]);



            Log.e("hey", "in TaskEditorFrag construvtor: " + groupId);


            editMode = true;
        }else{
            editMode = false;
        }

        button_add.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                toCreateSubjectFrag();
            }
        });

        button_send.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String title = editText_taskTitle.getText().toString().trim();
                if (str_year != null && str_month != null && str_day != null) {
                    if (title.length() < 2) {
                        textView_error.setText("A cím túl rövid (minimum 2 karakter)");
                    } else if (title.length() > 20) {
                        textView_error.setText("A cím túl hosszú (maximum 20 karakter)");
                    }else if (spinner_subject.getSelectedItem() == null){
                        textView_error.setText("Nincs kiválasztott témád");
                    } else {
                        button_send.setEnabled(false);
                        if(editMode){
                            editTask();
                        }else{
                            createTask();
                        }
                    }
                }else{
                    textView_error.setText("Nem állítottál be határidőt");
                }
                AndroidThings.closeKeyboard(getContext(), v);
            }
    });


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
        //dpd.getDatePicker().setMaxDate(Calendar.getInstance().getTimeInMillis() - 1000);
        dpd.getDatePicker().setMinDate(Calendar.getInstance().getTimeInMillis() - 1000);

        HashMap<String, Object> vars = new HashMap<>();
        vars.put("groupId", Integer.toString(groupId));
        MiddleMan.newRequest(this.getActivity(),"getSubjects", null, rh_subjects, vars);

        return v;
    }



    private void editTask() {
        HashMap<String, Object> requestBody = new HashMap<>();

        String tType;
        switch (spinner_taskType.getSelectedItem().toString()) {
            case "teszt":
                tType = "test";
                break;
            case "házi feladat":
                tType = "homework";
                break;
            default:
                tType = "házi feladat";
                break;
        }

        requestBody.put("taskType", tType);
        requestBody.put("taskTitle", editText_taskTitle.getText().toString().trim());
        requestBody.put("description", editText_description.getText().toString());
        requestBody.put("subjectId", ((POJOsubject) spinner_subject.getSelectedItem()).getId());//((POJOsubject) subject_spinner.getSelectedItem()).getId());
        Log.e("hey", "date: " + year + "-" + month + "-" + day);
        requestBody.put("dueDate", str_year + "-" + str_month + "-" + str_day);

        HashMap<String, Object> vars = new HashMap<>();
        vars.put("groupId", Integer.toString(groupId));
        vars.put("taskId", Integer.toString(taskId));

        //  MiddleMan.request.TaskEditor(this.getActivity(), requestBody, rh_taskTypes, vars);

        MiddleMan.newRequest(this.getActivity(), "editTask", requestBody, rh_task, vars);
    }

    private void createTask() {
        HashMap<String, Object> requestBody = new HashMap<>();

        String tType;
        switch (spinner_taskType.getSelectedItem().toString()) {
            case "teszt":
                tType = "test";
                break;
            case "házi feladat":
                tType = "homework";
                break;
            default:
                tType = "házi feladat";
                break;
        }

        requestBody.put("taskType", tType);
        requestBody.put("taskTitle", editText_taskTitle.getText().toString().trim());
        requestBody.put("description", editText_description.getText().toString());
        requestBody.put("subjectId", ((POJOsubject) spinner_subject.getSelectedItem()).getId());//((POJOsubject) subject_spinner.getSelectedItem()).getId());
        Log.e("hey", "date: " + year + "-" + month + "-" + day);
        requestBody.put("dueDate", str_year + "-" + str_month + "-" + str_day);

        HashMap<String, Object> vars = new HashMap<>();
        vars.put("id", Integer.toString(groupId));

        //  MiddleMan.request.TaskEditor(this.getActivity(), requestBody, rh_taskTypes, vars);

        MiddleMan.newRequest(this.getActivity(), "createTask", requestBody, rh_task, vars);

    }

    @Override
    public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
    }
    @Override
    public void onNothingSelected(AdapterView<?> adapterView) {
    }

    void toMainGroupFrag(){
        Transactor.fragmentMainGroup(getFragmentManager().beginTransaction(),groupId, groupName);
    }
    void toCreateSubjectFrag(){
        Manager.DestManager.setDest(Manager.DestManager.TOCREATETASK);
        Transactor.fragmentCreateSubject(getFragmentManager().beginTransaction(), groupId, groupName);
    }
    public int getGroupId(){
        return groupId;
    }
    public String getGroupName(){
        return groupName;
    }

}
