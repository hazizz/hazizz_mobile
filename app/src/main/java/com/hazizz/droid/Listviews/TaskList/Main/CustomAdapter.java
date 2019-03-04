package com.hazizz.droid.Listviews.TaskList.Main;

import android.app.Activity;
import android.content.Context;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.hazizz.droid.D8;
import com.hazizz.droid.Listviews.HeaderHolder;
import com.hazizz.droid.Listviews.HeaderItem;
import com.hazizz.droid.Listviews.TaskList.TaskItem;
import com.hazizz.droid.R;

import java.util.List;

public class CustomAdapter extends BaseAdapter{

    Context context;
    List<Object> data;

    private static final int HEADER_ITEM = 1;
    private static final int NORMAL_ITEM = 0;


    public CustomAdapter(@NonNull Context context, @NonNull List<Object> objects) {
      //  super(context, objects);
        this.context = context;
        this.data = objects;
    }

    static class DataHolder{
        TextView taskTitle;
        TextView taskDescription;
        TextView taskDueDate;
        TextView taskGroup;
        TextView taskGroup_;
        TextView taskSubject;
    }
    @NonNull
    @Override
    public View getView(int position, @Nullable View convertView, @NonNull ViewGroup parent) {
        DataHolder holder = null;
        HeaderHolder headerHolder = null;

        if(convertView == null) {
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();
            if(getItemViewType(position) == NORMAL_ITEM){
               // convertView = inflater.inflate(picID, parent, false);
                convertView = inflater.inflate(R.layout.task_main_item, null);
                holder = new DataHolder();
                holder.taskTitle = (TextView) convertView.findViewById(R.id.task_title);
                holder.taskDescription = (TextView) convertView.findViewById(R.id.task_description);
               // holder.taskDueDate = (TextView) convertView.findViewById(R.id.textView_dueDate);
                holder.taskGroup = (TextView) convertView.findViewById(R.id.textView_group);
                holder.taskGroup_ = (TextView) convertView.findViewById(R.id.textView_creator);
                holder.taskSubject = (TextView) convertView.findViewById(R.id.textView_subject);
                convertView.setTag(holder);
            }
            else if(getItemViewType(position) == HEADER_ITEM){
                convertView = inflater.inflate(R.layout.header_item, null);
                headerHolder = new HeaderHolder();
                headerHolder.title = (TextView) convertView.findViewById(R.id.textView_title);
                headerHolder.deadline = (TextView) convertView.findViewById(R.id.textView_deadline);

                convertView.setTag(holder);
            }

        }else{
            if(getItemViewType(position) == NORMAL_ITEM){
                holder = (DataHolder)convertView.getTag();
            }else{
                headerHolder = (HeaderHolder)convertView.getTag();
            }
        }

        if(holder != null){
            TaskItem taskItem = (TaskItem)data.get(position);
          //  D8.Date deadLineDate = D8.textToDate(taskItem.getTaskDueDate());
          //  holder.taskDueDate.setText(deadLineDate.getMainFormat());
            holder.taskTitle.setText(taskItem.getTaskTitle());
            holder.taskDescription.setText(taskItem.getTaskDescription());

            if(taskItem.getGroup() != null) {
                holder.taskGroup.setText(taskItem.getGroup().getName());
            }else{
                holder.taskGroup_.setVisibility(View.GONE);
                holder.taskGroup.setVisibility(View.GONE);
            }
            if(taskItem.getSubject() != null) {
                holder.taskSubject.setText(taskItem.getSubject().getName() + ":");
            }else{
                holder.taskSubject.setVisibility(View.GONE);
            }
        }
        else if(headerHolder != null){
            String date = ((HeaderItem) data.get(position)).getDate();

            int daysLeft = D8.textToDate(date).daysLeft();
            String deadline = D8.textToDate(date).getMainFormat();

            String title;
            if(daysLeft == 0){
                title = context.getResources().getString(R.string.today);
            }else if(daysLeft == 1){
                title = context.getResources().getString(R.string.tomorrow);
            } else {
                title = context.getResources().getString(R.string.header_item_in) + " " + daysLeft + " " + context.getResources().getString(R.string.header_item_day) + " " + context.getResources().getString(R.string.header_item_later);
            }

            headerHolder.title.setText(title);

            headerHolder.deadline.setText(deadline);
        }
        return convertView;
    }

    @Override
    public int getViewTypeCount() {
        return 2;
    }

    @Override
    public int getItemViewType(int position) {
        if(data.get(position) instanceof TaskItem){
            return NORMAL_ITEM;
        }
        return HEADER_ITEM;
    }

    @Override
    public int getCount() {
        return data.size();
    }

    @Nullable
    @Override
    public Object getItem(int position) {
        return data.get(position);
    }

    @Override
    public long getItemId(int position) {
        return 0;
    }

    public void clear(){
        data.clear();
        notifyDataSetChanged();
    }
}
