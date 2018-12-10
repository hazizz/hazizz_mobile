package com.indeed.hazizz.Listviews.AnnouncementList.Group;

import android.app.Activity;
import android.content.Context;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.indeed.hazizz.Listviews.AnnouncementList.AnnouncementItem;
import com.indeed.hazizz.R;

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
        TextView taskCreator;
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
            holder.taskCreator = (TextView) convertView.findViewById(R.id.textView_group);
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
        holder.taskCreator.setText(announcementItem.getCreator().getUsername());
       /* if(announcementItem.getSubjectData() == null) {
            holder.taskSubject.setVisibility(View.INVISIBLE);
            holder.taskSubject_.setVisibility(View.INVISIBLE);
        }else{
            holder.taskSubject.setText(announcementItem.getSubjectData().getName());
        } */
        //  holder.taskPic.setImageResource(announcementItem.taskPic);

        return convertView;
        // return super.getView(position, convertView, parent);
    }
}
