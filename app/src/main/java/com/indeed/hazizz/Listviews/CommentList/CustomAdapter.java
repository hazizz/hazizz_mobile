package com.indeed.hazizz.Listviews.CommentList;

import android.app.Activity;
import android.content.Context;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;

import com.indeed.hazizz.Communication.Strings;
import com.indeed.hazizz.Converter.Converter;
import com.indeed.hazizz.Manager;
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
        ImageView commentProfilePic;
        TextView commentName;
        TextView commentContent;
        View badge_owner;
    }
    @NonNull
    @Override
    public View getView(int position, @Nullable View convertView, @NonNull ViewGroup parent) {
        DataHolder holder = null;

        if(convertView == null) {
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();

            convertView = inflater.inflate(picID, parent, false);

            holder = new DataHolder();
            holder.commentProfilePic = (ImageView) convertView.findViewById(R.id.imageView_memberProfilePic);
            holder.commentName = (TextView) convertView.findViewById(R.id.subject_name);
            holder.commentContent = (TextView) convertView.findViewById(R.id.textView_description);
            holder.badge_owner = (FrameLayout) convertView.findViewById(R.id.badge_owner);

            convertView.setTag(holder);
        }else{
            holder = (DataHolder)convertView.getTag();
        }
        CommentItem commentItem = data.get(position);
        holder.commentProfilePic.setImageBitmap(Converter.getCroppedBitmap(Converter.scaleBitmapToRegular(Converter.imageFromText(commentItem.getCommentProfilePic()))));
        holder.commentName.setText(commentItem.getCreator().getDisplayName());
        holder.commentContent.setText(commentItem.getCommentContent());

        if(Manager.GroupRankManager.getRank((int)commentItem.getCreator().getId()).equals(Strings.Rank.OWNER)){
            holder.badge_owner.setVisibility(View.VISIBLE);
        }else if(Manager.GroupRankManager.getRank((int)commentItem.getCreator().getId()).equals(Strings.Rank.MODERATOR)){

        }else if(Manager.GroupRankManager.getRank((int)commentItem.getCreator().getId()).equals(Strings.Rank.USER)){

        }
        return convertView;
    }

}
