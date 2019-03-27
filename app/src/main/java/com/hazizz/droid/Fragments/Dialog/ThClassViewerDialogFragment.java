package com.hazizz.droid.Fragments.Dialog;

import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import com.hazizz.droid.D8;
import com.hazizz.droid.Listviews.TheraReturnSchedules.ClassItem;
import com.hazizz.droid.R;

public class ThClassViewerDialogFragment extends DialogFragment {

    ClassItem classItem;

    TextView textView_start;
    TextView textView_end;
    TextView textView_subject;
    TextView textView_date;
    TextView textView_count;
    TextView getTextView_classgroup;
    TextView textView_teacher;
    TextView textView_classroom;


    TextView textView_canceled;
    TextView textView_standin;
    TextView textView_standin_teacher;

    TextView textView_teacher_;


    Button button_close;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.dialog_fragment_th_class_viewer, container, false);

        classItem = getArguments().getParcelable("class");

       // D8.Date dateText = D8.textToDate(getArguments().getString(Transactor.KEY_DATE));

        textView_start = v.findViewById(R.id.textView_weight);
        textView_end = v.findViewById(R.id.textView_topic);
        textView_canceled = v.findViewById(R.id.textView_canceled);
         textView_standin = v.findViewById(R.id.textView_standin);
        textView_standin_teacher = v.findViewById(R.id.textView_standin_teacher);
         textView_subject = v.findViewById(R.id.textView_subject);
         textView_date = v.findViewById(R.id.textView_date);
         textView_count = v.findViewById(R.id.textView_grade);
         getTextView_classgroup = v.findViewById(R.id.textView_classgroup);
         textView_teacher = v.findViewById(R.id.textView_teacher);
         textView_classroom = v.findViewById(R.id.textView_classroom);

        textView_teacher_ = v.findViewById(R.id.textView_teacher_);

        textView_start.setText(classItem.getStartOfClass());
        textView_end.setText(classItem.getEndOfClass());
        if(classItem.isCancelled()){
            textView_canceled.setVisibility(View.VISIBLE);
        }
        if(classItem.isStandIn()){
            textView_standin.setVisibility(View.VISIBLE);
            textView_standin_teacher.setVisibility(View.VISIBLE);
            textView_standin_teacher.setText(classItem.getTeacher());
            textView_teacher.setVisibility(View.GONE);
            textView_teacher_.setVisibility(View.GONE);
        }else{
            textView_teacher.setText(classItem.getTeacher());
        }
        textView_subject.setText(classItem.getSubject());
        textView_date.setText(D8.textToDate(classItem.getDate()).getMainFormat());
        textView_count.setText(classItem.getPeriodNumber() + ".");
        getTextView_classgroup.setText(classItem.getClassName());
        textView_classroom.setText(classItem.getRoom());
        button_close = v.findViewById(R.id.button_close);
        button_close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });


        return v;
    }
}