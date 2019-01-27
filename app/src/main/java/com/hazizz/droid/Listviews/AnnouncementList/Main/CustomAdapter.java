package com.hazizz.droid.Listviews.AnnouncementList.Main;

import android.app.Activity;
import android.content.Context;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.hazizz.droid.Listviews.AnnouncementList.AnnouncementItem;
import com.hazizz.droid.R;

import java.util.List;

public class CustomAdapter extends ArrayAdapter<AnnouncementItem> {

    Context context;
    int picID;
    List<AnnouncementItem> data = null;


    public CustomAdapter(@NonNull Context context, int resource, @NonNull List<AnnouncementItem> objects) {
        super(context, resource, objects);

        this.picID = resource;
        this.context = context;
        this.data = objects;
    }

    static class DataHolder{
        // ImageView taskPic;
        TextView taskTitle;
        TextView taskDescription;
        TextView taskGroup;
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
            holder.taskTitle = (TextView) convertView.findViewById(R.id.announcement_title);
            holder.taskDescription = (TextView) convertView.findViewById(R.id.announcement_description);
            holder.taskGroup = (TextView) convertView.findViewById(R.id.textView_creator);
         //   holder.taskSubject = (TextView) convertView.findViewById(R.id.textView_title);
        //    holder.taskSubject_ = (TextView) convertView.findViewById(R.id.textView_subject_);
            convertView.setTag(holder);
        }else{
            holder = (DataHolder)convertView.getTag();
        }

        AnnouncementItem announcementItem = data.get(position);
        holder.taskTitle.setText(announcementItem.getAnnouncementTitle());
        holder.taskDescription.setText(announcementItem.getAnnouncementDescription());
        //   holder.taskCreator.setText(announcementItem.getCreator().getUsername());
        holder.taskGroup.setText(announcementItem.getGroup().getName());
       /* if(announcementItem.getSubject() == null) {
            holder.taskSubject.setVisibility(View.INVISIBLE);
            holder.taskSubject_.setVisibility(View.INVISIBLE);
        }else{
            holder.taskSubject.setText(announcementItem.getSubject().getName());
        } */
        //  holder.taskPic.setImageResource(announcementItem.taskPic);

        return convertView;
        // return super.getView(position, convertView, parent);
    }
}
