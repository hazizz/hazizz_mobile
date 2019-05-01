package com.hazizz.droid.listviews.TheraGradesList;

import android.app.Activity;
import android.content.Context;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.FragmentManager;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hazizz.droid.R;
import com.hazizz.droid.other.TheraGradeColorer;
import com.hazizz.droid.navigation.Transactor;

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
        TextView textView_average;
        LinearLayout homeMadeList_grades;
    }
    @NonNull
    @Override
    public View getView(int position, @Nullable View convertView, @NonNull ViewGroup parent) {
        DataHolder holder = null;
        View listItem = LayoutInflater.from(context).inflate(R.layout.th_grade_subject_item, parent, false);


        if(convertView == null) {
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();

            convertView = inflater.inflate(picID, parent, false);

            holder = new DataHolder();


            holder.textView_average = convertView.findViewById(R.id.textView_average);
            holder.textView_subjectName = convertView.findViewById(R.id.textView_subjectName);
            holder.homeMadeList_grades = (LinearLayout) convertView.findViewById(R.id.linearLayout_grades);

            convertView.setTag(holder);
        }else{
            holder = (DataHolder)convertView.getTag();
        }

        TheraSubjectGradesItem th_subjectItem = data.get(position);

        holder.textView_subjectName.setText(th_subjectItem.getSubjectName());
        addGrade(th_subjectItem.getGrades(), convertView, holder);

        return convertView;
    }

    private void addGrade(List<TheraGradesItem> grades, View listItem, DataHolder holder){
        LinearLayout homeMadeList_grades = listItem.findViewById(R.id.linearLayout_grades);
        homeMadeList_grades.removeAllViews();
        double total = 0;
        double amount = 0;
        for(int i = 0; i < grades.size(); i++){

            TheraGradesItem grade = grades.get(i);
            int weight = Integer.parseInt(grade.getWeight());

            try {
                amount += (weight/100);
                total += Integer.parseInt(grade.getGrade()) * (weight/100);
            }catch (Exception ignore){}

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
        if(amount != 0) {
            double average = total / amount;
            holder.textView_average.setText(String.format("%.2f", average));
        }else{
            holder.textView_average.setText("0.0");
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
