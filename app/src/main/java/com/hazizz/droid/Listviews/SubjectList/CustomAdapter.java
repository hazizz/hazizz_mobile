package com.hazizz.droid.Listviews.SubjectList;

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

public class CustomAdapter extends ArrayAdapter<SubjectItem> {

    Context context;
    int picID;
    List<SubjectItem> data = null;


    public CustomAdapter(@NonNull Context context, int resource, @NonNull List<SubjectItem> objects) {
        super(context, resource, objects);

        this.picID = resource;
        this.context = context;
        this.data = objects;
    }

    static class DataHolder{
        // ImageView taskPic;
        TextView subjectName;
    }
    @NonNull
    @Override
    public View getView(int position, @Nullable View convertView, @NonNull ViewGroup parent) {
        DataHolder holder = null;

        if(convertView == null) {
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();

            convertView = inflater.inflate(picID, parent, false);

            holder = new DataHolder();
            holder.subjectName = (TextView) convertView.findViewById(R.id.subject_name);
            convertView.setTag(holder);
        }else{
            holder = (DataHolder)convertView.getTag();
        }

        SubjectItem subjectItem = data.get(position);
        holder.subjectName.setText(subjectItem.getSubjectName());
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
