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

import com.crashlytics.android.answers.Answers;
import com.crashlytics.android.answers.CustomEvent;
import com.indeed.hazizz.Activities.MainActivity;
import com.indeed.hazizz.AndroidThings;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.POJO.Response.POJOsubject;
import com.indeed.hazizz.Communication.Strings;
import com.indeed.hazizz.D8;
import com.indeed.hazizz.Manager;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class TaskEditorFragment extends Fragment implements AdapterView.OnItemSelectedListener{

    private String[] taskTypeArray;

    private boolean editMode = false;

    private Integer year, month, day;
    private String str_year, str_month, str_day;

    private int groupId;
    private String groupName;
    private int subject;
    private int taskId;

    private Spinner spinner_subject;
    private TextView textView_subject;
    private TextView textView_fragment_title;

    private Spinner spinner_taskType;
    private EditText editText_taskTitle;
    private EditText editText_description;
    private Button button_send;
    private Button button_add;
    private TextView textView_error;
    private TextView textView_deadline;

    private DatePickerDialog dpd;

    private long typeId = 0;
    private String typeName, date;

    private List<POJOsubject> subjects = new ArrayList<>();

    private View v;

    ArrayAdapter<POJOsubject> s_adapter;

    CustomResponseHandler rh_task = new CustomResponseHandler() {
        @Override
        public void onPOJOResponse(Object response) {
            Log.e("hey", "got POJOresponse");
        }
        @Override
        public void onErrorResponse(POJOerror error) {
            Log.e("hey", error.getMessage());
            int errorCode = error.getErrorCode();
            if(errorCode == 2){ // cím túl hosszú (2-20 karatket)
                textView_error.setText(R.string.error_titleNotAcceptable);
            }
            button_send.setEnabled(true);
            Answers.getInstance().logCustom(new CustomEvent("create/edit task")
                    .putCustomAttribute("status", errorCode)
            );
        }
        @Override
        public void onSuccessfulResponse() {
            if(Manager.DestManager.getDest() == Manager.DestManager.TOGROUP){
                Transactor.fragmentGroupTask(getFragmentManager().beginTransaction(),groupId, groupName);
            }else if(Manager.DestManager.getDest() == Manager.DestManager.TOMAIN){
                Transactor.fragmentMainTask(getFragmentManager().beginTransaction());
            }
            else{
                Transactor.fragmentMainTask(getFragmentManager().beginTransaction());
            }
            Answers.getInstance().logCustom(new CustomEvent("create/edit task")
                    .putCustomAttribute("status", "success")
            );
        }
        @Override
        public void onNoConnection() {
            textView_error.setText(R.string.info_noInternetAccess);
            button_send.setEnabled(true);
        }
    };
    CustomResponseHandler rh_subjects = new CustomResponseHandler() {
        @Override
        public void onPOJOResponse(Object response) {
            subjects = (ArrayList<POJOsubject>)response;
            s_adapter.clear();
            s_adapter.add(new POJOsubject(0, getString(R.string.subject_none)));
            if(subjects.size() != 0) {
                int emSubjectId = 0;
                for (POJOsubject s : subjects) {
                    s_adapter.add(s);
                    if (subject == s.getId()) {
                        emSubjectId = s.getId();
                    }
                }
                s_adapter.notifyDataSetChanged();
                if (editMode) {
                    spinner_subject.setSelection(emSubjectId);
                }
            }
            s_adapter.notifyDataSetChanged();
        }
        @Override
        public void onFailure(Call<ResponseBody> call, Throwable t) {
            Log.e("hey", "got here onFailure");
            Log.e("hey", "subject fail");
        }
        @Override
        public void onNoConnection() {
            textView_error.setText(R.string.info_noInternetAccess);
            button_send.setEnabled(true);
        }
    };

    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_taskeditor, container, false);

        ((MainActivity)getActivity()).onFragmentCreated();

        spinner_subject = (Spinner)v.findViewById(R.id.subject_spinner);
        textView_subject = v.findViewById(R.id.textView_subject);
        button_send = (Button)v.findViewById(R.id.button_send);
        button_add = v.findViewById(R.id.add_button);
        spinner_taskType = (Spinner)v.findViewById(R.id.taskType_spinner);
        editText_taskTitle = v.findViewById(R.id.taskTitle);
        editText_description = v.findViewById(R.id.editText_description);
        editText_description.setImeOptions(EditorInfo.IME_ACTION_DONE);
        editText_description.setRawInputType(InputType.TYPE_CLASS_TEXT);
        textView_error = v.findViewById(R.id.textView_error_currentPassword);
        textView_error.setTextColor(Color.rgb(255, 0, 0));

        textView_fragment_title = v.findViewById(R.id.fragment_info);

        textView_deadline = v.findViewById(R.id.textView_deadline);

        textView_deadline.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view) {
                dpd.show();
            }
        });

        taskTypeArray = getResources().getStringArray(R.array.taskTypes);
        List<String> taskTypeList = Arrays.asList(taskTypeArray);

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(
                getActivity(),
                android.R.layout.simple_list_item_1,
                taskTypeList );

        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner_taskType.setAdapter(adapter);



        groupId = Manager.GroupManager.getGroupId();
        groupName = Manager.GroupManager.getGroupName();
        taskId = getArguments().getInt("taskId");

        if(taskId != 0 || typeName != null) {
            subject = getArguments().getInt("subjectId");
            date = getArguments().getString("date");
            textView_deadline.setText(R.string.deadline_ );
            textView_deadline.append(" " + date);
            editText_taskTitle.setText(getArguments().getString("title"));
            editText_description.setText(getArguments().getString("description"));
            typeId = getArguments().getLong("typeId");
     //       typeName = getArguments().getString("typeName");

            textView_subject.setText(getArguments().getString("subjectName"));

          /*  for(int i = 0 ; i <= taskTypeArray.length-1; i++){
                if(typeName.equals(taskTypeArray[i])){
                    spinner_taskType.setSelection(i);
                    break;
                }
            } */
            spinner_subject.setVisibility(View.INVISIBLE);
            button_add.setVisibility(View.INVISIBLE);

            textView_fragment_title.setText(R.string.fragment_title_edit_task);

            String[] taskTypeArray = getResources().getStringArray(R.array.taskTypes);
            spinner_taskType.setSelection((int)typeId-1);

            editMode = true;
        }else{
            // subject spinner
            s_adapter = new ArrayAdapter<POJOsubject>(getContext(), android.R.layout.simple_spinner_item);
            s_adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
            spinner_subject.setAdapter(s_adapter);
            spinner_subject.setOnItemSelectedListener(this);
            EnumMap<Strings.Path, Object> vars = new EnumMap<>(Strings.Path.class);
            vars.put(Strings.Path.GROUPID, Integer.toString(groupId));
            MiddleMan.newRequest(this.getActivity(),"getSubjects", null, rh_subjects, vars);

            textView_fragment_title.setText(R.string.fragment_title_new_task);

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
                if (str_year != null && str_month != null && str_day != null || editMode) {
                    if (title.length() < 2 || title.length() > 20) {
                        textView_error.setText(R.string.error_titleLentgh);
                    }else if (spinner_subject.getSelectedItem() == null){
                        if(editMode){
                            editTask();
                        }else {
                            textView_error.setText(R.string.error_subjectNotSelected);
                        }
                    } else {
                        button_send.setEnabled(false);
                        if(editMode){
                            editTask();
                        }else{
                            createTask();
                        }
                    }
                }else{
                    textView_error.setText(R.string.error_deadlineNotSet);
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
                textView_deadline.setText(R.string.deadline_ );
                textView_deadline.append(" " + str_year + "." + str_month + "."+ str_day);
            }
        }, Integer.parseInt(D8.getYear()), Integer.parseInt(D8.getMonth()) -2, Integer.parseInt(D8.getDay()));
        //dpd.getDatePicker().setMaxDate(Calendar.getInstance().getTimeInMillis() - 1000);
        dpd.getDatePicker().setMinDate(Calendar.getInstance().getTimeInMillis() - 1000);

        return v;
    }

    private void editTask() {
        HashMap<String, Object> requestBody = new HashMap<>();

        int tTypeId = spinner_taskType.getSelectedItemPosition() + 1;

        Log.e("hey", "task type: "+tTypeId);

        requestBody.put("taskType", tTypeId);
        requestBody.put("taskTitle", editText_taskTitle.getText().toString().trim());
        requestBody.put("description", editText_description.getText().toString());
        Log.e("hey", "date: " + year + "-" + month + "-" + day);
        if(str_day != null && str_month != null && str_year != null) {
            requestBody.put("dueDate", str_year + "-" + str_month + "-" + str_day);
        }else{
            requestBody.put("dueDate", date);
        }
        EnumMap<Strings.Path, Object> vars = new EnumMap<>(Strings.Path.class);
        vars.put(Strings.Path.WHERENAME, Strings.Path.TASKS.toString());
        if(subject == 0) {
            vars.put(Strings.Path.BYNAME, Strings.Path.GROUPS.toString());
            vars.put(Strings.Path.BYID, groupId);
        }else{
            vars.put(Strings.Path.BYNAME, Strings.Path.SUBJECTS.toString());
            vars.put(Strings.Path.BYID, subject);
        }
        vars.put(Strings.Path.WHEREID, taskId);

        MiddleMan.newRequest(this.getActivity(), "editAT", requestBody, rh_task, vars);
    }

    private void createTask() {
        HashMap<String, Object> requestBody = new HashMap<>();

        int tTypeId = spinner_taskType.getSelectedItemPosition() + 1;
        Log.e("hey", "task type: "+tTypeId);
        requestBody.put("taskType", tTypeId);
        requestBody.put("taskTitle", editText_taskTitle.getText().toString().trim());
        requestBody.put("description", editText_description.getText().toString());
        Log.e("hey", "date: " + year + "-" + month + "-" + day);
        requestBody.put("dueDate", str_year + "-" + str_month + "-" + str_day);

        EnumMap<Strings.Path, Object> vars = new EnumMap<>(Strings.Path.class);
        vars.put(Strings.Path.WHERENAME, Strings.Path.TASKS.toString());

        int subjectId = ((POJOsubject) spinner_subject.getSelectedItem()).getId();

        if(subjectId == 0){
            vars.put(Strings.Path.BYNAME, Strings.Path.GROUPS.toString());
            vars.put(Strings.Path.BYID, Integer.toString(groupId));
        }else{
            vars.put(Strings.Path.BYNAME, Strings.Path.SUBJECTS.toString());
            vars.put(Strings.Path.BYID, subjectId);
        }

        MiddleMan.newRequest(this.getActivity(), "createAT", requestBody, rh_task, vars);

    }
    @Override
    public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
    }
    @Override
    public void onNothingSelected(AdapterView<?> adapterView) {
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
