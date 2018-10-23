package com.indeed.hazizz.Listviews.UserList;

import android.app.Activity;
import android.content.Context;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.indeed.hazizz.Listviews.TaskList.TaskItem;
import com.indeed.hazizz.R;

import java.util.List;

public class CustomAdapter extends ArrayAdapter<UserItem> {

    Context context;
    int picID;
    List<UserItem> data = null;


    public CustomAdapter(@NonNull Context context, int resource, @NonNull List<UserItem> objects) {
        super(context, resource, objects);

        this.picID = resource;
        this.context = context;
        this.data = objects;
    }

    static class DataHolder{
       // ImageView taskPic;
        TextView userName;
    }
    @NonNull
    @Override
    public View getView(int position, @Nullable View convertView, @NonNull ViewGroup parent) {
        DataHolder holder = null;

        if(convertView == null) {
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();

            convertView = inflater.inflate(picID, parent, false);

            holder = new DataHolder();
           // holder.taskPic = (ImageView) convertView.findViewById(R.id.task_pic);
            holder.userName = (TextView) convertView.findViewById(R.id.textView_userName);

            convertView.setTag(holder);
        }else{
            holder = (DataHolder)convertView.getTag();
        }

        UserItem userItem = data.get(position);
        holder.userName.setText(userItem.getUserName());
      //  holder.taskPic.setImageResource(taskItem.taskPic);

        return convertView;
        // return super.getView(position, convertView, parent);
    }
}
