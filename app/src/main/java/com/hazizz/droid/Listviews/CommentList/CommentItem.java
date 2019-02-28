package com.hazizz.droid.Listviews.CommentList;

import android.app.Activity;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.widget.PopupMenu;
import android.view.MenuItem;
import android.view.View;

import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.getTaskPOJOs.POJOcreator;
import com.hazizz.droid.Communication.Requests.DeleteATComment;
import com.hazizz.droid.Communication.Requests.GetCommentSection;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Fragments.CommentableFragments.CommentableFragment;
import com.hazizz.droid.R;
import com.hazizz.droid.Transactor;

import lombok.Data;

@Data
public class CommentItem {

    Strings.Rank groupRank;
    long commentId;
    String commentProfilePic;
    POJOcreator creator;
    String commentContent;
    private boolean canModify;

    public void setModify(boolean b){
        canModify = b;
    }

    public CommentItem(long commentId, String commentProfilePic, Strings.Rank groupRank, POJOcreator creator, String commentContent){
        this.commentId = commentId;
        this.commentProfilePic = commentProfilePic;
        this.groupRank = groupRank;
        this.creator = creator;
        this.commentContent = commentContent;
    }

    public void showMenu(Activity act, CustomResponseHandler rh, int taskId, View v, FragmentTransaction ft, CommentableFragment commentableFragment){



        PopupMenu popup = new PopupMenu(act, v);

        popup.getMenuInflater().inflate(R.menu.menu_comment_item_popup, popup.getMenu());

        if(canModify){
            popup.getMenu().getItem(2).setVisible(true);
            popup.getMenu().getItem(3).setVisible(true);
        }

        popup.setOnMenuItemClickListener(new PopupMenu.OnMenuItemClickListener() {
            @Override
            public boolean onMenuItemClick(MenuItem item) {
                switch (item.getItemId()){
                    case R.id.popupitem_reply:
                        break;
                    case R.id.popupitem_viewProfile:
                        Transactor.fragmentDialogShowUserDetailDialog(ft, creator.getId(), groupRank.getValue(), commentProfilePic);
                        break;
                    case R.id.popupitem_edit:
                        commentableFragment.editComment(commentId, commentContent);
                        break;
                    case R.id.popupitem_delete:
                        MiddleMan.newRequest(new DeleteATComment(act, new CustomResponseHandler(){
                            @Override
                            public void onSuccessfulResponse() {
                                MiddleMan.newRequest(new GetCommentSection(act, rh, Strings.Path.TASKS.toString(), (int)taskId));
                            }
                        }, Strings.Path.TASKS, (int)taskId, commentId));
                        break;
                }
                popup.dismiss();


                return false;
            }
        });
        popup.show();
    }


}
