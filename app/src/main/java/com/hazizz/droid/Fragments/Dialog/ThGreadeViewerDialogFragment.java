package com.hazizz.droid.Fragments.Dialog;

import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import com.hazizz.droid.D8;
import com.hazizz.droid.Listviews.TheraGradesList.TheraGradesItem;
import com.hazizz.droid.R;
import com.hazizz.droid.TheraGradeColorer;

public class ThGreadeViewerDialogFragment extends DialogFragment {

    TheraGradesItem gradeItem;

    TextView textView_date;
    TextView creationDate;
    TextView textView_subject;
    TextView textView_topic;
    TextView textView_gradeType;
    TextView textView_weight;
    TextView textView_grade;

    Button button_close;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.dialog_fragment_th_grade_viewer, container, false);

        gradeItem = getArguments().getParcelable("grade");

        textView_subject = v.findViewById(R.id.textView_subject);
        textView_date = v.findViewById(R.id.textView_date);
        textView_weight = v.findViewById(R.id.textView_start);
        textView_topic = v.findViewById(R.id.textView_end);
        textView_grade = v.findViewById(R.id.textView_count);

        textView_grade.setTextColor(TheraGradeColorer.getColor(getContext(), gradeItem.getWeight()));
        textView_weight.setTextColor(TheraGradeColorer.getColor(getContext(), gradeItem.getWeight()));

        textView_subject.setText(gradeItem.getSubject());
        textView_date.setText(D8.textToDate(gradeItem.getDate()).getMainFormat());
        textView_weight.setText(gradeItem.getWeight() + "%");
        textView_topic.setText(gradeItem.getTopic());
        textView_grade.setText(gradeItem.getGrade());

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