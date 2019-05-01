package com.hazizz.droid.listviews.UserList;

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

import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.converter.Converter;
import com.hazizz.droid.R;

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
        ImageView userProfilePic;
        TextView userName;
        FrameLayout badge_owner;
    }
    @NonNull
    @Override
    public View getView(int position, @Nullable View convertView, @NonNull ViewGroup parent) {
        DataHolder holder = null;

        if(convertView == null) {
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();

            convertView = inflater.inflate(picID, parent, false);

            holder = new DataHolder();
            holder.userProfilePic = (ImageView) convertView.findViewById(R.id.imageView_memberProfilePic);
            holder.userName = (TextView) convertView.findViewById(R.id.textView_name);
            holder.badge_owner = convertView.findViewById(R.id.badge_owner);

            convertView.setTag(holder);
        }else{
            holder = (DataHolder)convertView.getTag();
        }

        UserItem userItem = data.get(position);
        if(userItem.getUserProfilePic() != null && !userItem.getUserProfilePic().equals("")) {
            holder.userProfilePic.setImageBitmap(Converter.getCroppedBitmap(Converter.scaleBitmapToRegular(Converter.imageFromText(getContext(),userItem.userProfilePic))));
        }else{
            holder.userProfilePic.setImageResource(R.mipmap.ic_launcher_round);
        }
        holder.userName.setText(userItem.getDisplayName());


        if(userItem.userRank == Strings.Rank.OWNER.getValue()){
            holder.badge_owner.setVisibility(View.VISIBLE);
        }else if(userItem.userRank == Strings.Rank.MODERATOR.getValue()){

        }else if(userItem.userRank == Strings.Rank.USER.getValue()){

        }else{
        }

        return convertView;
    }
}
