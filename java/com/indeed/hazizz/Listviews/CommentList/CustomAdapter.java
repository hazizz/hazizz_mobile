package com.indeed.hazizz.Listviews.CommentList;

import android.app.Activity;
import android.content.Context;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.indeed.hazizz.Converter.Converter;
import com.indeed.hazizz.Listviews.TaskList.TaskItem;
import com.indeed.hazizz.R;

import java.util.List;

public class CustomAdapter extends ArrayAdapter<CommentItem>  {



    Context context;
    int picID;
    List<CommentItem> data = null;


    public CustomAdapter(@NonNull Context context, int resource, @NonNull List<CommentItem> objects) {
        super(context, resource, objects);

        this.picID = resource;
        this.context = context;
        this.data = objects;
    }

    static class DataHolder{
        // ImageView taskPic;
        ImageView commentProfilePic;
        TextView commentName;
        TextView commentContent;
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
            holder.commentProfilePic = (ImageView) convertView.findViewById(R.id.imageView_profilePic);
            holder.commentName = (TextView) convertView.findViewById(R.id.textView_userName);
            holder.commentContent = (TextView) convertView.findViewById(R.id.textView_description);

            convertView.setTag(holder);
        }else{
            holder = (DataHolder)convertView.getTag();
        }

        CommentItem commentItem = data.get(position);
        if(!commentItem.getCommentProfilePic().equals("")) {
            holder.commentProfilePic.setImageBitmap(Converter.imageFromText(commentItem.getCommentProfilePic()));
        }
        holder.commentName.setText(commentItem.getCommentName());
        holder.commentContent.setText(commentItem.getCommentContent());
        //   holder.taskCreator.setText(taskItem.getCreator().getUsername());
        //  holder.taskPic.setImageResource(taskItem.taskPic);

        return convertView;
        // return super.getView(position, convertView, parent);
    }

}
