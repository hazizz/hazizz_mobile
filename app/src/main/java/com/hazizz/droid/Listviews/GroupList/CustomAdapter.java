package com.hazizz.droid.Listviews.GroupList;

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

public class CustomAdapter extends ArrayAdapter<GroupItem> {

    Context context;
    int picID;
    List<GroupItem> data = null;


    public CustomAdapter(@NonNull Context context, int resource, @NonNull List<GroupItem> objects) {
        super(context, resource, objects);

        this.picID = resource;
        this.context = context;
        this.data = objects;
    }

    static class DataHolder{
       // ImageView profilePic;
        TextView groupName;
    }
    @NonNull
    @Override
    public View getView(int position, @Nullable View convertView, @NonNull ViewGroup parent) {
        DataHolder holder = null;

        if(convertView == null) {
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();

            convertView = inflater.inflate(picID, parent, false);

            holder = new DataHolder();
            holder.groupName = (TextView) convertView.findViewById(R.id.group_name);

            convertView.setTag(holder);
        }else{
            holder = (DataHolder)convertView.getTag();
        }

        GroupItem groupItem = data.get(position);
        holder.groupName.setText(groupItem.groupName);
       // holder.profilePic.setImageResource(groupItem.pic);

        return convertView;
        // return super.getView(position, convertView, parent);
    }
}
