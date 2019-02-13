package com.hazizz.droid.Fragments;

import android.app.DatePickerDialog;
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
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;

import com.crashlytics.android.answers.Answers;
import com.crashlytics.android.answers.CustomEvent;
import com.hazizz.droid.Activities.MainActivity;
import com.hazizz.droid.AndroidThings;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.POJO.Response.POJOgroup;
import com.hazizz.droid.Communication.POJO.Response.POJOsubject;
import com.hazizz.droid.Communication.Requests.CreateAT;
import com.hazizz.droid.Communication.Requests.EditAT;
import com.hazizz.droid.Communication.Requests.GetGroupsFromMe;
import com.hazizz.droid.Communication.Requests.GetSubjects;
import com.hazizz.droid.Communication.Requests.MyTask.CreateMyTask;
import com.hazizz.droid.Communication.Requests.MyTask.EditMyTask;
import com.hazizz.droid.Communication.Requests.Request;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.D8;
import com.hazizz.droid.Manager;
import com.hazizz.droid.Transactor;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.R;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;


public class TaskEditorFragment extends Fragment {//implements AdapterView.OnItemSelectedListener{
    public static final short GROUPMODE = 0;
    public static final short MYMODE = 1;

    public static final short EDITMODE = 1;
    public static final short CREATEMODE = 0;

    private short where = 0;
    private short type = 0;

    private String[] taskTypeArray;


    private Integer year, month, day;
    private String str_year, str_month, str_day;

    private int groupId;
    private String groupName;
    private int subject;
    private int taskId;

    private TextView textView_group_;
    private TextView textView_group;
    private Spinner spinner_group;
    private Spinner spinner_subject;
    private TextView textView_subject;
    private TextView textView_subject_;

    private Spinner spinner_taskType;
    private EditText editText_taskTitle;
    private EditText editText_description;
    private Button button_send;
    private TextView textView_error;
    private TextView textView_deadline;

    private DatePickerDialog dpd;

    private long typeId = 0;
    private String typeName, date;

    private List<POJOsubject> subjects = new ArrayList<>();
    private List<POJOgroup> groups = new ArrayList<>();

    private View v;


    ArrayAdapter<POJOgroup> g_adapter;
    ArrayAdapter<POJOsubject> s_adapter;

    CustomResponseHandler rh_task = new CustomResponseHandler() {
        @Override
        public void onErrorResponse(POJOerror error) {
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
            if(!subjects.isEmpty()) {
                int emSubjectId = 0;
                for (POJOsubject s : subjects) {
                    s_adapter.add(s);
                    if (subject == s.getId()) {
                        emSubjectId = s.getId();
                    }
                }
                s_adapter.notifyDataSetChanged();
                if (type == EDITMODE) {
                    spinner_subject.setSelection(emSubjectId);
                }
            }
            s_adapter.notifyDataSetChanged();
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

        textView_group = (TextView)v.findViewById(R.id.textView_subject);
        textView_group_ = (TextView)v.findViewById(R.id.textView_creator);
        spinner_group = (Spinner)v.findViewById(R.id.group_spinner);
        spinner_subject = (Spinner)v.findViewById(R.id.subject_spinner);
        textView_subject = v.findViewById(R.id.textView_group);
        textView_subject_ = v.findViewById(R.id.textView_subject_);
        button_send = (Button)v.findViewById(R.id.button_send);
        spinner_taskType = (Spinner)v.findViewById(R.id.taskType_spinner);
        editText_taskTitle = v.findViewById(R.id.taskTitle);
        editText_description = v.findViewById(R.id.editText_description);
        editText_description.setImeOptions(EditorInfo.IME_ACTION_DONE);
        editText_description.setRawInputType(InputType.TYPE_CLASS_TEXT);
        textView_error = v.findViewById(R.id.textView_error_currentPassword);
        textView_error.setTextColor(Color.rgb(255, 0, 0));

        textView_deadline = v.findViewById(R.id.textView_deadline);

        textView_deadline.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View view) {
                dpd.show();
            }
        });

        textView_deadline.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                if(date != null){
                    Transactor.fragmentDialogDateViewer(getFragmentManager().beginTransaction(), date);
                }
                return true;
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

        groupId = Manager.GroupManager.getGroupId();//getArguments().getInt(Strings.Path.GROUPID.toString());

        if(getArguments() != null) {
            groupName = Manager.GroupManager.getGroupName();
            taskId = getArguments().getInt("taskId");

            where = getArguments().getShort("where");
            type = getArguments().getShort("type");

            if( type == EDITMODE ){//taskId != 0 || typeName != null) {
                subject = getArguments().getInt("subjectId");
                date = getArguments().getString("date");
                textView_deadline.setText(D8.textToDate(date).getMainFormat());
                editText_taskTitle.setText(getArguments().getString("title"));
                editText_description.setText(getArguments().getString("description"));
                typeId = getArguments().getLong("typeId");
                textView_subject.setText(getArguments().getString("subjectName"));
                textView_group.setText(getArguments().getString("groupName"));

                spinner_group.setVisibility(View.INVISIBLE);
                spinner_subject.setVisibility(View.INVISIBLE);

                spinner_taskType.setSelection((int)typeId-1);
                (getActivity()).setTitle(R.string.fragment_title_edit_task);
        }

        }else{
            g_adapter = new ArrayAdapter<POJOgroup>(getContext(), android.R.layout.simple_spinner_item);
            g_adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
            spinner_group.setAdapter(g_adapter);
            spinner_group.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
                @Override
                public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                    groupId = ((POJOgroup)spinner_group.getItemAtPosition(position)).getId();
                    MiddleMan.newRequest(new GetSubjects(getActivity(),rh_subjects, groupId));
                }
                @Override public void onNothingSelected(AdapterView<?> parent) { }
            });
            MiddleMan.newRequest(new GetGroupsFromMe(getActivity(), new CustomResponseHandler() {
                @Override public void onPOJOResponse(Object response) {
                    groups = (ArrayList<POJOgroup>) response;
                    g_adapter.clear();
                    //  g_adapter.add(new POJOsubject(0, getString(R.string.subject_none)));
                    if (!groups.isEmpty()) {
                        int emGroupId = 0;
                        for (POJOgroup s : groups) {
                            g_adapter.add(s);
                            if (groupId == s.getId()) {
                                emGroupId = s.getId();
                            }
                        }
                        s_adapter.notifyDataSetChanged();
                        if (type == EDITMODE) {
                            spinner_group.setSelection(emGroupId);
                        }
                    }
                    s_adapter.notifyDataSetChanged();
                }
            }));

            s_adapter = new ArrayAdapter<POJOsubject>(getContext(), android.R.layout.simple_spinner_item);
            s_adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
            spinner_subject.setAdapter(s_adapter);
       //     MiddleMan.newRequest(new GetSubjects(getActivity(),rh_subjects, groupId));

            (getActivity()).setTitle(R.string.fragment_title_new_task);
        }

        if(where == MYMODE){
            spinner_group.setVisibility(View.GONE);
            spinner_subject.setVisibility(View.GONE);
            textView_subject_.setVisibility(View.GONE);
            textView_group_.setVisibility(View.GONE);
            textView_subject.setVisibility(View.GONE);
            (getActivity()).setTitle(R.string.fragment_title_new_mytask);
        }

        button_send.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String title = editText_taskTitle.getText().toString().trim();
                if (str_year != null && str_month != null && str_day != null || type == EDITMODE) {
                    if (title.length() < 2 || title.length() > 20) {
                        textView_error.setText(R.string.error_titleLentgh);
                    }else if (spinner_subject.getSelectedItem() == null){
                        if(type == EDITMODE){
                            editTask();
                        }else if(where == MYMODE){
                            createTask();
                        }
                        else {
                            textView_error.setText(R.string.error_subjectNotSelected);
                        }
                    } else {
                        button_send.setEnabled(false);
                        if(type == EDITMODE){
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
                date = year + "-" + month + "-" + day;
                textView_deadline.setText(str_year + "." + str_month + "."+ str_day);
            }
        }, Integer.parseInt(D8.getYear()), Integer.parseInt(D8.getMonth()) -2, Integer.parseInt(D8.getDay()));
        //dpd.getDatePicker().setMaxDate(Calendar.getInstance().getTimeInMillis() - 1000);
        dpd.getDatePicker().setMinDate(Calendar.getInstance().getTimeInMillis() - 1000);

        return v;
    }

    private void editTask() {
        int tTypeId = spinner_taskType.getSelectedItemPosition() + 1;

        int taskType = tTypeId;
        String taskTitle = editText_taskTitle.getText().toString().trim();
        String description = editText_description.getText().toString();
        String dueDate;
        if(str_day != null && str_month != null && str_year != null) {
            dueDate = str_year + "-" + str_month + "-" + str_day;
        }else{
            dueDate = date;
        }
        Request r;
        if(where == GROUPMODE){
            r = new EditAT(getActivity(),rh_task, Strings.Path.TASKS,taskId,
                    taskType, taskTitle, description, dueDate);
        }else{
            r = new EditMyTask(getActivity(),rh_task,
                    taskId, taskType, taskTitle, description, dueDate);
        }
        MiddleMan.newRequest(r);
    }

    private void createTask() {

        int tTypeId = spinner_taskType.getSelectedItemPosition() + 1;
        String title = editText_taskTitle.getText().toString().trim();
        String description = editText_description.getText().toString();
        String dueDate = str_year + "-" + str_month + "-" + str_day;

        Request r;
        if(where == GROUPMODE){
            int subjectId = ((POJOsubject) spinner_subject.getSelectedItem()).getId();
            String byName;
            int byId;
            if (subjectId == 0) {
                byName = Strings.Path.GROUPS.toString();
                byId = groupId;
            } else {
                byName = Strings.Path.SUBJECTS.toString();
                byId = subjectId;
            }
            r = new CreateAT(getActivity(),rh_task, Strings.Path.TASKS, byName, byId,
                    tTypeId, title, description, dueDate);
        }else{
            r = new CreateMyTask(getActivity(),rh_task,
                    tTypeId, title, description, dueDate);
        }
        MiddleMan.newRequest(r);
    }
    public int getGroupId(){
        return groupId;
    }
    public String getGroupName(){
        return groupName;
    }

}
