package com.hazizz.droid.Listviews.TheraGradesList;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.FragmentManager;
import android.util.Log;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hazizz.droid.R;
import com.hazizz.droid.TheraGradeColorer;
import com.hazizz.droid.Transactor;

import java.util.List;

public class CustomAdapter extends ArrayAdapter<TheraSubjectGradesItem> {

    int picID;
    Context context;
    List<TheraSubjectGradesItem> data = null;
    FragmentManager fragmentManager;

   // DataHolder holder;

    public CustomAdapter(@NonNull Context context, int resource, @NonNull List<TheraSubjectGradesItem> objects, FragmentManager fragmentManager) {
        super(context, resource, objects);

        this.fragmentManager = fragmentManager;
        this.picID = resource;
        this.context = context;
        this.data = objects;
    }

    static class DataHolder{
        TextView textView_subjectName;
        LinearLayout homeMadeList_grades;
    }
    @NonNull
    @Override
    public View getView(int position, @Nullable View convertView, @NonNull ViewGroup parent) {
        DataHolder holder = null;

        View listItem = convertView;

        TheraSubjectGradesItem th_subjectItem = data.get(position);

        if(listItem == null) {

            listItem = LayoutInflater.from(context).inflate(R.layout.th_grade_subject_item, parent, false);

        }

        TextView textView_subjectName = listItem.findViewById(R.id.textView_subjectName);
        LinearLayout homeMadeList_grades = (LinearLayout) listItem.findViewById(R.id.linearLayout_grades);

        textView_subjectName.setText(th_subjectItem.getSubjectName());
        addGrade(th_subjectItem.getGrades(), listItem);

        Log.e("hey", "finished 123");

        return listItem;



    }


    private void addGrade(List<TheraGradesItem> grades, View listItem){
        LinearLayout homeMadeList_grades = listItem.findViewById(R.id.linearLayout_grades);
        homeMadeList_grades.removeAllViews();
        for(int i = 0; i < grades.size(); i++){

            TheraGradesItem grade = grades.get(i);

            TextView textView_grade = new TextView(context);

            textView_grade.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 40);


            textView_grade.setTextColor(TheraGradeColorer.getColor(context, grade.getWeight()));
            if(fragmentManager != null){
                textView_grade.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Transactor.fragmentThDialogGrade(fragmentManager, grade);
                    }
                });
            }

            textView_grade.setText(grade.getGrade());

            homeMadeList_grades.addView(textView_grade);

            if(i+1 != grades.size() ) {
                TextView textView_comma = new TextView(context);
                textView_comma.setText(", ");
                textView_comma.setTextColor(context.getResources().getColor(R.color.colorDarkText));

                textView_comma.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 40);
                homeMadeList_grades.addView(textView_comma);

            }
        }
    }

    /*private void addGrade(List<TheraGradesItem> grades, DataHolder holder){
        for(int i = 0; i < grades.size(); i++){

            TheraGradesItem grade = grades.get(i);

            grade.getWeight();

            TextView textView_grade = new TextView(context);

            textView_grade.setTextColor(context.getResources().getColor(R.color.colorDarkText));

            textView_grade.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 40);
            if(fragmentManager != null){
                textView_grade.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Transactor.fragmentThDialogGrade(fragmentManager, grade);
                    }
                });
            }

            holder.homeMadeList_grades.addView(textView_grade);
            Log.e("hey", "grade added");

            if(i+1 != grades.size() ) {
                textView_grade.setText(grade.getGrade() + ",");
            }else{
                textView_grade.setText(grade.getGrade());
                break;
            }
        }
    }*/

}
