package com.hazizz.droid.listviews.CommentList;

import android.app.Activity;
import android.content.Context;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.widget.PopupMenu;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;

import com.hazizz.droid.cache.MeInfo.MeInfo;
import com.hazizz.droid.communication.MiddleMan;

import com.hazizz.droid.communication.requests.DeleteATComment;
import com.hazizz.droid.communication.Strings;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.converter.Converter;
import com.hazizz.droid.enums.EnumAT;
import com.hazizz.droid.fragments.ParentFragment.CommentableFragment;
import com.hazizz.droid.R;
import com.hazizz.droid.navigation.Transactor;


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
        Menu menu;
        ImageView imageView_popup;
        ImageView commentProfilePic;
        TextView commentName;
        TextView commentContent;
        View badge_owner;
    }
    @NonNull
    @Override
    public View getView(int position, @Nullable View convertView, @NonNull ViewGroup parent) {
        DataHolder holder = null;


        CommentItem commentItem = data.get(position);

        if(convertView == null) {
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();

            convertView = inflater.inflate(picID, parent, false);

            holder = new DataHolder();

            holder.imageView_popup = convertView.findViewById(R.id.imageView_popup);
            holder.commentProfilePic = (ImageView) convertView.findViewById(R.id.imageView_memberProfilePic);
            holder.commentName = (TextView) convertView.findViewById(R.id.textView_name);
            holder.commentContent = (TextView) convertView.findViewById(R.id.textView_description);
            holder.badge_owner = (FrameLayout) convertView.findViewById(R.id.badge_owner);

            convertView.setTag(holder);
        }else{
            holder = (DataHolder)convertView.getTag();
        }

        holder.commentProfilePic.setImageBitmap(Converter.getCroppedBitmap(Converter.scaleBitmapToRegular(Converter.imageFromText(getContext(),commentItem.getCommentProfilePic()))));
        holder.commentName.setText(commentItem.getCreator().getDisplayName());
        holder.commentContent.setText(commentItem.getCommentContent());

        Strings.Rank rank = commentItem.getGroupRank();

        Log.e("hey", "hehjó: " + rank.toString() + ", " + rank.getValue() + ", " + commentItem.getCreator().getId());
        if(rank.getValue() == Strings.Rank.OWNER.getValue()){
            holder.badge_owner.setVisibility(View.VISIBLE);
            commentItem.setCanModify(true);
            Log.e("hey",  commentItem.getCreator().getUsername() + " is owner: " + commentItem.getCreator().getId());
       // }else if(rank.getValue() == Strings.Rank.MODERATOR.getValue()){
       // }else if(rank.getValue() == Strings.Rank.USER.getValue()){
        }else{
            holder.badge_owner.setVisibility(View.INVISIBLE);
        }
        if(commentItem.getCreator().getId() == MeInfo.getInstance().getUserId()){
            commentItem.setCanModify(true);
        }

        return convertView;
    }

    @Override
    public void clear() {
        super.clear();
        data.clear();
    }




    public void showMenu(Activity act, EnumAT whereName, int typeId, CommentItem commentItem, View v, FragmentTransaction ft, CommentableFragment commentableFragment){
        PopupMenu popup = new PopupMenu(act, v);

        popup.getMenuInflater().inflate(R.menu.menu_comment_item_popup, popup.getMenu());

        if(MeInfo.getInstance().getUserId() == commentItem.getCreator().getId() || MeInfo.getInstance().getRankInCurrentGroup().getValue() >= Strings.Rank.MODERATOR.getValue()) {
            popup.getMenu().getItem(3).setVisible(true);
        }

        popup.setOnMenuItemClickListener(new PopupMenu.OnMenuItemClickListener() {
            @Override
            public boolean onMenuItemClick(MenuItem item) {
                switch (item.getItemId()){
                    case R.id.popupitem_reply:
                        break;
                    case R.id.popupitem_viewProfile:
                        Transactor.fragmentDialogShowUserDetailDialog(ft, commentItem.getCreator().getId(), commentItem.groupRank.getValue(), commentItem.getCommentProfilePic());
                        break;
                    case R.id.popupitem_edit:
                        commentableFragment.editComment(commentItem.getCommentId(), commentItem.getCommentContent());
                        break;
                    case R.id.popupitem_delete:
                        MiddleMan.newRequest(new DeleteATComment(act, new CustomResponseHandler(){
                            @Override
                            public void onSuccessfulResponse() {
                                remove(commentItem);
                            }
                        }, whereName, typeId, commentItem.getCommentId()));
                        break;
                }
                popup.dismiss();


                return false;
            }
        });
        popup.show();
    }
}
