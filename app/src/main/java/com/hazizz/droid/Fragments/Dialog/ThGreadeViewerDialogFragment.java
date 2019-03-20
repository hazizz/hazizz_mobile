package com.hazizz.droid.Fragments.Dialog;

import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import com.hazizz.droid.Listviews.TheraGradesList.TheraGradesItem;
import com.hazizz.droid.R;

public class ThGreadeViewerDialogFragment extends DialogFragment {

    TheraGradesItem gradeItem;

    TextView textView_date;
    TextView textView_weight;
    TextView textView_theme;
    TextView textView_value;

    Button button_close;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.dialog_fragment_th_grade_viewer, container, false);

        gradeItem = getArguments().getParcelable("grade");

         textView_date = v.findViewById(R.id.textView_teacher);
        textView_weight = v.findViewById(R.id.textView_weight);
        textView_theme = v.findViewById(R.id.textView_theme);
        textView_value = v.findViewById(R.id.textView_value);

        textView_date.setText(gradeItem.getDate());
        textView_weight.setText(gradeItem.getWeight());
        textView_theme.setText(gradeItem.getTopic());
        textView_value.setText(gradeItem.getGrade());

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