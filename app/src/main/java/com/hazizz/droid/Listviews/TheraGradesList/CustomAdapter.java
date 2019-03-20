package com.hazizz.droid.Listviews.TheraGradesList;

import android.app.Activity;
import android.content.Context;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.util.DisplayMetrics;
import android.util.Log;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hazizz.droid.R;

import java.util.List;

public class CustomAdapter extends ArrayAdapter<TheraSubjectGradesItem> {

    int picID;
    Context context;
    List<TheraSubjectGradesItem> data = null;

   // DataHolder holder;

    public CustomAdapter(@NonNull Context context, int resource, @NonNull List<TheraSubjectGradesItem> objects) {
        super(context, resource, objects);

        this.picID = resource;
        this.context = context;
        this.data = objects;
    }

    static class DataHolder{
       // TextView textView_grade_example;
        TextView textView_subjectName;
        LinearLayout homeMadeList_grades;
    }
    @NonNull
    @Override
    public View getView(int position, @Nullable View convertView, @NonNull ViewGroup parent) {
        DataHolder holder = null;

        if(convertView == null) {
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();

            convertView = inflater.inflate(picID, parent, false);

            holder = new DataHolder();
            //holder.textView_grade_example = convertView.findViewById(R.id.textView_grade_example);
            holder.textView_subjectName = convertView.findViewById(R.id.textView_subjectName);
            holder.homeMadeList_grades = (LinearLayout) convertView.findViewById(R.id.linearLayout_grades);

            convertView.setTag(holder);
        }else{
            holder = (DataHolder)convertView.getTag();
        }

        TheraSubjectGradesItem th_subjectItem = data.get(position);

        holder.textView_subjectName.setText(th_subjectItem.getSubjectName());
        addGrade(th_subjectItem.getGrades(), holder);

        Log.e("hey", "finished 123");

        return convertView;
    }


    private void addGrade(List<TheraGradesItem> grades, DataHolder holder){
        for(int i = 0; i < grades.size(); i++){

            TheraGradesItem grade = grades.get(i);

            grade.getWeight();

            TextView textView_grade = new TextView(context);

            if(i+1 != grades.size() ) {
                textView_grade.setText(grade.getGrade() + ",");
            }else{
                textView_grade.setText(grade.getGrade());
            }

            textView_grade.setVisibility(View.VISIBLE);
            textView_grade.setTextColor(context.getResources().getColor(R.color.colorDarkText));



            textView_grade.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 40);
            textView_grade.setOnClickListener(new View.OnClickListener() {
                @Override public void onClick(View v) {

            }});

            holder.homeMadeList_grades.addView(textView_grade);
            Log.e("hey", "grade added");
        }
    }

}
