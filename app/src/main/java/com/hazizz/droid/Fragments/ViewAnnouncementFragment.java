package com.hazizz.droid.Fragments;


import android.app.AlertDialog;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.constraint.ConstraintLayout;
import android.support.v4.app.Fragment;
import android.support.v4.widget.NestedScrollView;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.PopupMenu;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import com.crashlytics.android.answers.Answers;
import com.crashlytics.android.answers.CustomEvent;
import com.hazizz.droid.Activities.MainActivity;
import com.hazizz.droid.AndroidThings;
import com.hazizz.droid.Communication.POJO.Response.AnnouncementPOJOs.POJODetailedAnnouncement;
import com.hazizz.droid.Communication.POJO.Response.CommentSectionPOJOs.POJOComment;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.GetUserPermissionInGroup;
import com.hazizz.droid.Communication.POJO.Response.POJOMembersProfilePic;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.POJO.Response.POJOuser;
import com.hazizz.droid.Communication.POJO.Response.PojoPermisionUsers;
import com.hazizz.droid.Communication.Requests.AddComment;
import com.hazizz.droid.Communication.Requests.DeleteAT;
import com.hazizz.droid.Communication.Requests.DeleteATComment;
import com.hazizz.droid.Communication.Requests.GetAT;
import com.hazizz.droid.Communication.Requests.GetCommentSection;
import com.hazizz.droid.Communication.Requests.GetGroupMemberPermisions;
import com.hazizz.droid.Communication.Requests.GetGroupMembersProfilePic;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Enum.EnumAT;
import com.hazizz.droid.Fragments.ParentFragment.CommentableFragment;
import com.hazizz.droid.Listviews.CommentList.CommentItem;
import com.hazizz.droid.Listviews.CommentList.CustomAdapter;
import com.hazizz.droid.Listviews.NonScrollListView;
import com.hazizz.droid.Manager;
import com.hazizz.droid.Transactor;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.R;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class ViewAnnouncementFragment extends CommentableFragment implements AdapterView.OnItemSelectedListener{


    private Button button_comments;
    private Button button_delete;
    private Button button_edit;

    private short enable_button_comment = 0;
    private int groupId, announcementId, creatorId;
    private String groupName;
    private String title;
    private String descripiton;

    private int dest;

    private TextView type;
    private TextView textView_title;
    private TextView textView_description;
    private TextView creatorName;
    private TextView group;

    private CustomResponseHandler rh;
    private CustomResponseHandler rh_delete = new CustomResponseHandler() {
        @Override
        public void onSuccessfulResponse() {
            button_delete.setEnabled(false);
        }
    };

    CustomResponseHandler permissionRh = new CustomResponseHandler() {
        @Override
        public void onPOJOResponse(Object response) {
            String rank = ((String)response);
            Log.e("hey", "talicska: " + rank);
            Strings.Rank r = Strings.Rank.NULL;
            if(Strings.Rank.USER.toString().equals(rank)){
                r = Strings.Rank.USER;
            }else if(Strings.Rank.MODERATOR.toString().equals(rank)){
                r = Strings.Rank.MODERATOR;
            }else if(Strings.Rank.OWNER.toString().equals(rank)) {
                r = Strings.Rank.OWNER;
            }
            Manager.MeInfo.setRankInCurrentGroup(r);

            Log.e("hey", "talicska 2: " + Manager.MeInfo.getRankInCurrentGroup().getValue() + " " + Manager.MeInfo.getRankInCurrentGroup().toString());

            if(Manager.MeInfo.getId() == creatorId || Manager.MeInfo.getRankInCurrentGroup().getValue() >= Strings.Rank.MODERATOR.getValue() ){
                button_delete.setVisibility(View.VISIBLE);
                button_edit.setVisibility(View.VISIBLE);
            }
        }
    };
    private boolean goBackToMain;
    private boolean gotResponse = false;

    private View v;

    private CommentableFragment self;


    // Comment part
    private TextView textView_commentTitle;
    private LinearLayout box_comment;

    private NestedScrollView scrollView;

    private CustomAdapter adapter;
    private List<CommentItem> listComment;
    private EditText editText_commentBody;
    private ImageButton button_send;
    private TextView textView_noContent;
    private SwipeRefreshLayout sRefreshLayout;

    private CustomResponseHandler getComments_rh = new CustomResponseHandler() {
        @Override
        public void onPOJOResponse(Object response) {
            adapter.clear();
            ArrayList<POJOComment> comments = (ArrayList<POJOComment>) response;
            HashMap<Integer, POJOMembersProfilePic> profilePicMap = Manager.ProfilePicManager.getCurrentGroupMembersProfilePic();
            if(comments.isEmpty()) {
                textView_noContent.setVisibility(v.VISIBLE);
            }else {
                adapter.clear();
                for (POJOComment t : comments) {
                    Strings.Rank rank = Manager.GroupRankManager.getRank((int)t.getCreator().getId());
                    listComment.add(new CommentItem(t.getId(), profilePicMap.get((int)t.getCreator().getId()).getData(),rank, t.getCreator(), t.getContent()));
                }
                adapter.notifyDataSetChanged();
                textView_noContent.setVisibility(v.INVISIBLE);
            }
            sRefreshLayout.setRefreshing(false);
        }
        @Override
        public void onFailure(Call<ResponseBody> call, Throwable t) {
            sRefreshLayout.setRefreshing(false);
        }
        @Override
        public void onErrorResponse(POJOerror error) {
            Log.e("hey", "onErrorResponse");
            sRefreshLayout.setRefreshing(false);
        }
        @Override
        public void onNoConnection() {
            textView_noContent.setText(R.string.info_noInternetAccess);
            textView_noContent.setVisibility(View.VISIBLE);
            sRefreshLayout.setRefreshing(false);
        }
    };



    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_viewannouncement, container, false);
        Log.e("hey", "im here lol");
        ((MainActivity)getActivity()).onFragmentCreated();

        getActivity().setTitle(R.string.title_fragment_view_announcement);

        type = v.findViewById(R.id.textView_tasktype);
        textView_title = v.findViewById(R.id.textView_subject);
        textView_description = v.findViewById(R.id.editText_description);
        creatorName = v.findViewById(R.id.textView_creator_);
        group = v.findViewById(R.id.textView_group);

        button_delete = v.findViewById(R.id.button_delete);
        button_edit = v.findViewById(R.id.button_edit);
        button_edit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(gotResponse){
                    Transactor.fragmentEditAnnouncement(getFragmentManager().beginTransaction(), Manager.GroupManager.getGroupId(), announcementId, Manager.GroupManager.getGroupName(), title, descripiton, Strings.Dest.TOGROUP);//commentId);
                }
            }});

        scrollView = v.findViewById(R.id.scrollView);

        button_delete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(gotResponse){
                    AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(getContext());
                    alertDialogBuilder.setTitle(R.string.delete);
                    alertDialogBuilder
                            .setMessage(R.string.areyousure_delete_announcement)
                            .setCancelable(true)
                            .setPositiveButton(R.string.yes, (dialog, id) -> {
                                CustomResponseHandler rh = new CustomResponseHandler() {
                                    @Override
                                    public void onSuccessfulResponse() {
                                        if(dest == Strings.Dest.TOGROUP.getValue()) {
                                            Transactor.fragmentGroupAnnouncement(getFragmentManager().beginTransaction(), Manager.GroupManager.getGroupId(), Manager.GroupManager.getGroupName());
                                        } else{
                                            Transactor.fragmentMainAnnouncement(getFragmentManager().beginTransaction());
                                        }
                                        Answers.getInstance().logCustom(new CustomEvent("delete announcement")
                                                .putCustomAttribute("status", "success")
                                        );
                                    }
                                    @Override
                                    public void onErrorResponse(POJOerror error) {
                                        button_delete.setEnabled(true);
                                        Answers.getInstance().logCustom(new CustomEvent("delete announcement")
                                                .putCustomAttribute("status", error.getErrorCode())
                                        );
                                    }
                                };
                                button_delete.setEnabled(false);
                                MiddleMan.newRequest(new DeleteAT(getActivity(), rh, Strings.Path.ANNOUNCEMENTS, announcementId));

                                dialog.cancel();
                            })
                            .setNegativeButton(R.string.no, (dialog, id) -> {
                                dialog.cancel();
                            });
                    AlertDialog alertDialog = alertDialogBuilder.create();
                    alertDialog.show();
                }
            }
        });
        /*
        button_comments = v.findViewById(R.id.button_comments);
        button_comments.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Transactor.fragmentCommentSection(getFragmentManager().beginTransaction(), Strings.Path.ANNOUNCEMENTS.toString(), announcementId);
            }
        });
        */




        editText_commentBody = v.findViewById(R.id.editText_comment_body);
        box_comment = v.findViewById(R.id.box_comment);
        textView_noContent = v.findViewById(R.id.textView_noContent);
        sRefreshLayout = v.findViewById(R.id.swipe_refresh_layout);
        sRefreshLayout.setColorSchemeColors(getResources().getColor(R.color.colorPrimaryDarkBlue), getResources().getColor(R.color.colorPrimaryLightBlue), getResources().getColor(R.color.colorPrimaryDarkBlue));
        sRefreshLayout.bringToFront();
        sRefreshLayout.setOnRefreshListener(() -> getComments());

        button_send = v.findViewById(R.id.button_send_comment);
        button_send.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String commentBody = editText_commentBody.getText().toString().trim();
                if (!commentBody.equals("")) {
                    button_send.setEnabled(false);
                    HashMap<String, Object> body = new HashMap<>();
                    body.put("content", commentBody);

                    MiddleMan.newRequest(new AddComment(getActivity(),new CustomResponseHandler() {
                        @Override
                        public void onFailure(Call<ResponseBody> call, Throwable t) {
                            button_send.setEnabled(true);
                        }
                        @Override
                        public void onErrorResponse(POJOerror error) {
                            button_send.setEnabled(true);
                            Answers.getInstance().logCustom(new CustomEvent("add comment")
                                    .putCustomAttribute("status", error.getErrorCode())
                            );
                        }
                        @Override
                        public void onSuccessfulResponse() {
                            getComments();
                            AndroidThings.closeKeyboard(getContext(), v);
                            editText_commentBody.setText("");
                            button_send.setEnabled(true);
                            Answers.getInstance().logCustom(new CustomEvent("add comment")
                                    .putCustomAttribute("status", "success")
                            );
                        }
                        @Override
                        public void onNoConnection() {
                            button_send.setEnabled(true);
                        }
                    }, Strings.Path.ANNOUNCEMENTS.toString(), announcementId, commentBody));
                }
            }
        });

        textView_commentTitle = v.findViewById(R.id.textView_commentTitle);
        textView_commentTitle.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new Handler().post(new Runnable() {
                    @Override
                    public void run() {
                        scrollView.smoothScrollTo(0, textView_commentTitle.getTop());
                    }
                });
            }
        });


        Bundle bundle = this.getArguments();
        if (bundle != null) {
            announcementId =  bundle.getInt(Transactor.KEY_ANNOUNCEMENTID);
            groupId = bundle.getInt(Transactor.KEY_GROUPID);


            groupName = bundle.getString(Transactor.KEY_GROUPNAME);
            goBackToMain = bundle.getBoolean(Transactor.KEY_GOBACKTOMAIN);

            dest = bundle.getInt(Transactor.KEY_DEST);

        }else{Log.e("hey", "bundle is null");}
        rh = new CustomResponseHandler() {
            @Override
            public void onPOJOResponse(Object response) {
                POJODetailedAnnouncement pojoResponse = (POJODetailedAnnouncement)response;

                Manager.GroupManager.setGroupId(pojoResponse.getGroup().getId());
                Manager.GroupManager.setGroupName(pojoResponse.getGroup().getName());

                groupId = pojoResponse.getGroup().getId();

                CustomResponseHandler r2 = new CustomResponseHandler() {
                    @Override
                    public void onPOJOResponse(Object response) {
                        PojoPermisionUsers pojoPermisionUser = (PojoPermisionUsers)response;
                        if(pojoPermisionUser != null) {
                            if(pojoPermisionUser.getOWNER() != null) {
                                for (POJOuser u : pojoPermisionUser.getOWNER()) {
                                    Manager.GroupRankManager.setRank(u.getId(), Strings.Rank.OWNER);
                                }
                            }if(pojoPermisionUser.getMODERATOR() != null) {
                                for (POJOuser u : pojoPermisionUser.getMODERATOR()) {
                                    Log.e("hey", "555: MODI");
                                    Manager.GroupRankManager.setRank(u.getId(), Strings.Rank.MODERATOR);
                                }
                            }if(pojoPermisionUser.getUSER() != null) {
                                for (POJOuser u : pojoPermisionUser.getUSER()) {
                                    Log.e("hey", "555: USER");
                                    Manager.GroupRankManager.setRank(u.getId(), Strings.Rank.USER);
                                }
                            }
                        }
                        enable_button_comment++;
                        visibleIfEnabled_button_comment();
                    }
                };
                MiddleMan.newRequest(new GetGroupMemberPermisions(getActivity(), r2, groupId));

                creatorId = (int)pojoResponse.getCreator().getId();

                MiddleMan.newRequest(new GetUserPermissionInGroup(getActivity(), permissionRh, groupId, (int)Manager.MeInfo.getId()));


                if(Manager.ProfilePicManager.getCurrentGroupId() != groupId || dest == Strings.Dest.TOMAIN.getValue()){
                    CustomResponseHandler responseHandler = new CustomResponseHandler() {
                        @Override
                        public void onPOJOResponse(Object response) {
                            Manager.ProfilePicManager.setCurrentGroupMembersProfilePic((HashMap<Integer, POJOMembersProfilePic>)response, groupId);
                            getComments();
                            enable_button_comment++;
                            visibleIfEnabled_button_comment();
                        }
                    };
                    MiddleMan.newRequest(new GetGroupMembersProfilePic(getActivity(),responseHandler, groupId));
                }else{
                    enable_button_comment++;
                    visibleIfEnabled_button_comment();
                }

                announcementId = pojoResponse.getId();

                gotResponse = true;
                title = pojoResponse.getTitle();
                descripiton = pojoResponse.getDescription();
                textView_title.setText(title);
                textView_description.setText(descripiton);
                creatorName.setText(pojoResponse.getCreator().getDisplayName());
                group.setText(pojoResponse.getGroup().getName());

            }
        };
        createViewList();
        getData();

        self = this;

        return v;
    }

    @Override public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        ConstraintLayout mainLayout = (ConstraintLayout) v.findViewById(R.id.constraintLayout);
        mainLayout.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                int h = mainLayout.getMeasuredHeight();
                if(h > 0) {
                    mainLayout.getViewTreeObserver().removeGlobalOnLayoutListener(this);
                    ConstraintLayout mainLayout = (ConstraintLayout) v.findViewById(R.id.constraintLayout);
                    ViewGroup.LayoutParams params = mainLayout.getLayoutParams();
                    params.height = h;
                    mainLayout.setLayoutParams(new LinearLayout.LayoutParams(params));
                }
            }
        });
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        Manager.GroupManager.leftGroup();
    }

    @Override
    public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
    }
    @Override
    public void onNothingSelected(AdapterView<?> adapterView) {
    }

    public int getGroupId(){
        return groupId;
    }
    public String getGroupName(){
        return groupName;
    }
    public boolean getGoBackToMain(){
        return goBackToMain;
    }

    public void visibleIfEnabled_button_comment(){
        if(enable_button_comment > 1){
            button_send.setVisibility(View.VISIBLE);
          //  editText_commentBody.setVisibility(View.VISIBLE);
            textView_commentTitle.setVisibility(View.VISIBLE);
            box_comment.setVisibility(View.VISIBLE);
        }
    }

    void createViewList(){
        listComment = new ArrayList<>();

        NonScrollListView listView = (NonScrollListView)v.findViewById(R.id.listView_comments);
        listView.setFocusable(false);
      /*  listView.setOnTouchListener(new View.OnTouchListener() {
            // Setting on Touch Listener for handling the touch inside ScrollView
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                // Disallow the touch request for parent scroll on touch of child view
                v.getParent().requestDisallowInterceptTouchEvent(true);
                return false;
            }
        });
        */

        adapter = new CustomAdapter(getActivity(), R.layout.comment_item, listComment);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
             //   Transactor.fragmentDialogShowUserDetailDialog(getFragmentManager().beginTransaction(), (long)adapter.getItem(i).getCreator().getId(), adapter.getItem(i).getCommentProfilePic());

                //     Transactor.fragmentDialogShowUserDetailDialog(getFragmentManager().beginTransaction(), (long)adapter.getItem(i).getCreator().getId(), adapter.getItem(i).getCommentProfilePic());
                ImageView imageView_popup = view.findViewById(R.id.imageView_popup);

                // Context wrapper = new ContextThemeWrapper(null, R.style.popupMenuStyle);
                adapter.getItem(i).showMenu(getActivity(), getComments_rh, EnumAT.ANNOUNCEMENTS, announcementId, imageView_popup, getFragmentManager().beginTransaction(), self);
                /*
                PopupMenu popup = new PopupMenu(getActivity(), view_position_popup);

                popup.getMenuInflater().inflate(R.menu.menu_comment_item_popup, popup.getMenu());
                popup.setOnMenuItemClickListener(new PopupMenu.OnMenuItemClickListener() {
                    @Override
                    public boolean onMenuItemClick(MenuItem item) {
                        switch (item.getItemId()){
                            case R.id.popupitem_edit:
                                break;
                            case R.id.popupitem_delete:
                                MiddleMan.newRequest(new DeleteATComment(getActivity(), new CustomResponseHandler(){
                                    @Override
                                    public void onSuccessfulResponse() {
                                        getComments();
                                    }
                                }, Strings.Path.ANNOUNCEMENTS, announcementId, commentId));
                                break;
                        }
                        popup.dismiss();

                        return false;
                    }
                });
                popup.show();
                */

            }
        });
    }

    @Override
    public void editComment(long commentId, String content) {
        super.editComment(commentId, content);

    }

    private void getComments(){
        MiddleMan.newRequest(new GetCommentSection(getActivity(), getComments_rh, Strings.Path.ANNOUNCEMENTS.toString(), announcementId));
    }

    private void getData(){
        MiddleMan.newRequest(new GetAT(getActivity(),rh, Strings.Path.ANNOUNCEMENTS, announcementId));
    }

}

