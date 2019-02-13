package com.hazizz.droid.Listviews.TaskList.Group;

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

public class CustomAdapter extends BaseAdapter {

    private Context context;
    private List<Object> data;

    private static final int HEADER_ITEM = 1;
    private static final int NORMAL_ITEM = 0;

    public CustomAdapter(@NonNull Context context, @NonNull List<Object> objects) {

        this.context = context;
        this.data = objects;
    }

    static class DataHolder{
        TextView taskTitle;
        TextView taskDescription;
        TextView taskDueDate;
        TextView taskCreator;
        TextView taskSubject;
    }

    @Override
    public int getItemViewType(int position) {
        if(data.get(position) instanceof TaskItem){
            return NORMAL_ITEM;
        }
        return HEADER_ITEM;
    }

    @Override
    public int getViewTypeCount() {
        return 2;
    }

    @Override
    public int getCount() {
        return data.size();
    }

    @Override
    public Object getItem(int position) {
        return data.get(position);
    }

    @Override
    public long getItemId(int position) {
        return 0;
    }

    @NonNull
    @Override
    public View getView(int position, @Nullable View convertView, @NonNull ViewGroup parent) {
        DataHolder holder = null;
        HeaderHolder headerHolder = null;

        if(convertView == null) {
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();
            if(getItemViewType(position) == NORMAL_ITEM) {
                convertView = inflater.inflate(R.layout.task_item, null);

                holder = new DataHolder();
                // holder.taskPic = (ImageView) convertView.findViewById(R.id.task_pic);
                holder.taskTitle = (TextView) convertView.findViewById(R.id.task_title);
                holder.taskDescription = (TextView) convertView.findViewById(R.id.task_description);
               // holder.taskDueDate = (TextView) convertView.findViewById(R.id.textView_dueDate);
                holder.taskCreator = (TextView) convertView.findViewById(R.id.textView_creator_);
                holder.taskSubject = (TextView) convertView.findViewById(R.id.textView_subject);
                convertView.setTag(holder);

            }else if(getItemViewType(position) == HEADER_ITEM){
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
            Log.e("hey", "else happened");
        }

        if(holder != null){
            TaskItem taskItem = (TaskItem) data.get(position);

          //  D8.Date deadLineDate = D8.textToDate(taskItem.getTaskDueDate());
          //  holder.taskDueDate.setText(deadLineDate.getMainFormat());

            holder.taskTitle.setText(taskItem.getTaskTitle());
            holder.taskDescription.setText(taskItem.getTaskDescription());

            holder.taskCreator.setText(taskItem.getCreator().getUsername());
            if (taskItem.getSubject() != null) {
                holder.taskSubject.setText(taskItem.getSubject().getName() + ":");
            } else {
                holder.taskSubject.setVisibility(View.GONE);
            }
        }else if(headerHolder != null) {
            HeaderItem headerItem = (HeaderItem) data.get(position);
            headerHolder.title.setText(headerItem.getTitle());
            headerHolder.deadline.setText(headerItem.getDeadline());
        }
        return convertView;
    }

    public void clear(){
        data.clear();
        notifyDataSetChanged();
    }
}
