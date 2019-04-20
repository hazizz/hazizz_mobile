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
        TextView taskTitle;
        TextView taskDescription;
        TextView taskGroup;
        TextView subject;
    }
    @NonNull
    @Override
    public View getView(int position, @Nullable View convertView, @NonNull ViewGroup parent) {
        DataHolder holder = null;

        if(convertView == null) {
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();

            convertView = inflater.inflate(picID, parent, false);

            holder = new DataHolder();
            holder.taskTitle = (TextView) convertView.findViewById(R.id.textView_subjectName);
            holder.taskDescription = (TextView) convertView.findViewById(R.id.textView_start);
            holder.taskGroup = (TextView) convertView.findViewById(R.id.textView_creator);
            holder.subject = (TextView) convertView.findViewById(R.id.textView_subject);
            convertView.setTag(holder);
        }else{
            holder = (DataHolder)convertView.getTag();
        }

        AnnouncementItem announcementItem = data.get(position);
        holder.taskTitle.setText(announcementItem.getAnnouncementTitle());
        holder.taskDescription.setText(announcementItem.getAnnouncementDescription());
        holder.taskGroup.setText(announcementItem.getGroup().getName());

        if(announcementItem.getSubject() != null){
            holder.subject.setText(announcementItem.getSubject().getName());
        }else{
            holder.subject.setVisibility(View.GONE);
        }

        return convertView;
    }
}
