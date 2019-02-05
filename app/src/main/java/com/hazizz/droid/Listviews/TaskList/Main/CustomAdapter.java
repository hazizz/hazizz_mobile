package com.hazizz.droid.Listviews.TaskList.Main;

import android.app.Activity;
import android.content.Context;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.hazizz.droid.D8;
import com.hazizz.droid.Listviews.TaskList.TaskItem;
import com.hazizz.droid.R;

import org.joda.time.LocalDate;

import java.util.List;

public class CustomAdapter extends ArrayAdapter<TaskItem> {

    Context context;
    int picID;
    List<TaskItem> data = null;


    public CustomAdapter(@NonNull Context context, int resource, @NonNull List<TaskItem> objects) {
        super(context, resource, objects);

        this.picID = resource;
        this.context = context;
        this.data = objects;
    }

    static class DataHolder{
        TextView taskTitle;
        TextView taskDescription;
        TextView taskDueDate;
        TextView taskGroup;
        TextView taskSubject;
    }
    @NonNull
    @Override
    public View getView(int position, @Nullable View convertView, @NonNull ViewGroup parent) {
        DataHolder holder = null;

        if(convertView == null) {
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();

            convertView = inflater.inflate(picID, parent, false);

            holder = new DataHolder();
            holder.taskTitle = (TextView) convertView.findViewById(R.id.task_title);
            holder.taskDescription = (TextView) convertView.findViewById(R.id.task_description);
            holder.taskDueDate = (TextView) convertView.findViewById(R.id.textView_dueDate);
            holder.taskGroup = (TextView) convertView.findViewById(R.id.textView_group);
            holder.taskSubject = (TextView) convertView.findViewById(R.id.textView_subject);
            convertView.setTag(holder);
        }else{
            holder = (DataHolder)convertView.getTag();
        }



        TaskItem taskItem = data.get(position);


        D8.Date deadLineDate = D8.textToDate(taskItem.getTaskDueDate());
        holder.taskDueDate.setText(deadLineDate.getMainFormat());



        holder.taskTitle.setText(taskItem.getTaskTitle());
        holder.taskDescription.setText(taskItem.getTaskDescription());

        holder.taskGroup.setText(taskItem.getGroup().getName());
        if(taskItem.getSubject() != null) {
            holder.taskSubject.setText(taskItem.getSubject().getName() + ":");
        }else{
            holder.taskSubject.setVisibility(View.GONE);
        }

        return convertView;
    }
}
