package com.hazizz.droid.Listviews.TheraGradesList;

import android.app.Activity;
import android.content.Context;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.hazizz.droid.R;

import java.util.List;

public class CustomAdapter extends ArrayAdapter<TheraGradesItem> {

    int picID;
    Context context;
    List<TheraGradesItem> data = null;


    public CustomAdapter(@NonNull Context context, int resource, @NonNull List<TheraGradesItem> objects) {
        super(context, resource, objects);

        this.picID = resource;
        this.context = context;
        this.data = objects;
    }

    static class DataHolder{
        TextView textView_grade_number;
        TextView textView_date;
        TextView textView_theme;
        TextView textView_weight;
    }
    @NonNull
    @Override
    public View getView(int position, @Nullable View convertView, @NonNull ViewGroup parent) {
        DataHolder holder = null;

        if(convertView == null) {
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();

            convertView = inflater.inflate(picID, parent, false);

            holder = new DataHolder();
            holder.textView_grade_number = convertView.findViewById(R.id.textView_subjectName);
            holder.textView_date = convertView.findViewById(R.id.textView_teacher);
            holder.textView_theme = convertView.findViewById(R.id.textView_start);
            holder.textView_weight = convertView.findViewById(R.id.textView_weight);

            convertView.setTag(holder);
        }else{
            holder = (DataHolder)convertView.getTag();
        }

        TheraGradesItem th_gradeItem = data.get(position);

        holder.textView_grade_number.setText(Integer.toString(th_gradeItem.getNumberValue()));
        holder.textView_date.setText("" + th_gradeItem.getDate());
        holder.textView_theme.setText(th_gradeItem.getTheme());
        holder.textView_weight.setText(th_gradeItem.getWeight());




        return convertView;
    }
}
