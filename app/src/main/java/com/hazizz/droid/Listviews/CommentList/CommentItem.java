package com.hazizz.droid.listviews.CommentList;

import android.util.Log;

import com.hazizz.droid.communication.Strings;
import com.hazizz.droid.communication.responsePojos.taskPojos.PojoCreator;

import lombok.Data;

@Data
public class CommentItem {

    Strings.Rank groupRank;
    long commentId;
    String commentProfilePic;
    PojoCreator creator;
    String commentContent;
    private boolean canModify;

    public void setModify(boolean b){
        canModify = b;
    }

    public CommentItem(long commentId, String commentProfilePic, Strings.Rank groupRank, PojoCreator creator, String commentContent){
        Log.e("hey", "creatorId" + creator.getId() + "\nprofile  pic: " + commentProfilePic);


        this.commentId = commentId;
        this.commentProfilePic = commentProfilePic;
        this.groupRank = groupRank;
        this.creator = creator;
        this.commentContent = commentContent;
    }

  /*  private void showMenu(Activity act, CustomResponseHandler updateComments_rh, EnumAT whereName, int typeId, View v, FragmentTransaction ft, CommentableFragment commentableFragment){

        PopupMenu popup = new PopupMenu(act, v);

        popup.getMenuInflater().inflate(R.menu.menu_comment_item_popup, popup.getMenu());

        if(canModify){
         //   popup.getMenu().getItem(2).setVisible(true);
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
                                MiddleMan.newRequest(new GetCommentSection(act, updateComments_rh, whereName.toString(), (int)typeId));
                            }
                        }, whereName, (int)typeId, commentId));
                        break;
                }
                popup.dismiss();


                return false;
            }
        });
        popup.show();
    }
    */


}
