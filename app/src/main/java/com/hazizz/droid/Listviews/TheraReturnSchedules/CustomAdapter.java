package com.hazizz.droid.Listviews.TheraReturnSchedules;

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

public class CustomAdapter extends ArrayAdapter<ClassItem> {

    int picID;
    Context context;
    List<ClassItem> data = null;

    public CustomAdapter(@NonNull Context context, int resource, @NonNull List<ClassItem> objects) {
        super(context, resource, objects);

        this.picID = resource;
        this.context = context;
        this.data = objects;
    }

    static class DataHolder{
        TextView textView_count;
        TextView textView_start;
        TextView textView_end;
        TextView textView_subjectName;
        TextView textView_teacher;
        TextView textView_classroom;
    }
    @NonNull
    @Override
    public View getView(int position, @Nullable View convertView, @NonNull ViewGroup parent) {
        DataHolder holder = null;

        if(convertView == null) {
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();

            convertView = inflater.inflate(picID, parent, false);

            holder = new DataHolder();
            holder.textView_count= convertView.findViewById(R.id.textView_grade);
            holder.textView_start= convertView.findViewById(R.id.textView_weight);
            holder.textView_end= convertView.findViewById(R.id.textView_topic);
            holder.textView_subjectName = convertView.findViewById(R.id.textView_subjectName);
            holder.textView_teacher = convertView.findViewById(R.id.textView_date);
            holder.textView_classroom = convertView.findViewById(R.id.textView_classroom);

            convertView.setTag(holder);
        }else{
            holder = (DataHolder)convertView.getTag();
        }

        ClassItem classItem = data.get(position);

        holder.textView_subjectName.setText(classItem.getSubject());
        holder.textView_teacher.setText(classItem.getTeacher());
        holder.textView_classroom.setText(classItem.getRoom());
        holder.textView_count.setText(classItem.getPeriodNumber() + ".");
        holder.textView_start.setText(classItem.getStartOfClass());
        holder.textView_end.setText(classItem.getEndOfClass());

        return convertView;
    }
}
