package com.hazizz.droid.fragments;

import android.app.AlertDialog;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.constraint.ConstraintLayout;
import android.support.v4.widget.NestedScrollView;
import android.support.v4.widget.SwipeRefreshLayout;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.crashlytics.android.answers.Answers;
import com.crashlytics.android.answers.CustomEvent;
import com.hazizz.droid.activities.MainActivity;
import com.hazizz.droid.other.AndroidThings;
import com.hazizz.droid.cache.CurrentGroup;
import com.hazizz.droid.cache.CurrentMembersManager;
import com.hazizz.droid.cache.MeInfo.MeInfo;
import com.hazizz.droid.cache.Member;
import com.hazizz.droid.Communication.requests.AddComment;
import com.hazizz.droid.Communication.requests.DeleteAT;
import com.hazizz.droid.Communication.requests.GetAT;
import com.hazizz.droid.Communication.requests.GetCommentSection;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Communication.responsePojos.announcementPojos.PojoAnnouncementDetailed;
import com.hazizz.droid.Communication.responsePojos.commentSectionPojos.PojoComment;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.Communication.responsePojos.PojoError;
import com.hazizz.droid.enums.EnumAT;
import com.hazizz.droid.fragments.ParentFragment.CommentableFragment;
import com.hazizz.droid.listeners.GenericListener;
import com.hazizz.droid.listviews.CommentList.CommentItem;
import com.hazizz.droid.listviews.CommentList.CustomAdapter;
import com.hazizz.droid.listviews.NonScrollListView;
import com.hazizz.droid.navigation.Transactor;
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

    private MeInfo meInfo;
    private CurrentGroup currentGroup;

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
            meInfo.setRankInCurrentGroup(r);

            Log.e("hey", "talicska 2: " + meInfo.getRankInCurrentGroup().getValue() + " " + meInfo.getRankInCurrentGroup().toString());

            if(meInfo.getUserId() == creatorId || meInfo.getRankInCurrentGroup().getValue() >= Strings.Rank.MODERATOR.getValue() ){
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





    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_viewannouncement, container, false);
        Log.e("hey", "im here lol");
        ((MainActivity)getActivity()).onFragmentCreated();

        getActivity().setTitle(R.string.title_fragment_view_announcement);

        currentGroup = CurrentGroup.getInstance();

        meInfo = MeInfo.getInstance();

        type = v.findViewById(R.id.textView_tasktype);
        textView_title = v.findViewById(R.id.textView_subject);
        textView_description = v.findViewById(R.id.editText_description);
        creatorName = v.findViewById(R.id.textView_creator);
        group = v.findViewById(R.id.textView_group);

        button_delete = v.findViewById(R.id.button_delete);
        button_edit = v.findViewById(R.id.button_edit);
        button_edit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(gotResponse){
                    Transactor.fragmentEditAnnouncement(getFragmentManager().beginTransaction(), (int)currentGroup.getGroupId(), announcementId, currentGroup.getGroupName(), title, descripiton, Strings.Dest.TOGROUP);//commentId);
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
                                            Transactor.fragmentGroupAnnouncement(getFragmentManager().beginTransaction(), (int)currentGroup.getGroupId(), currentGroup.getGroupName());
                                        } else{
                                            Transactor.fragmentMainAnnouncement(getFragmentManager().beginTransaction());
                                        }
                                        Answers.getInstance().logCustom(new CustomEvent("delete announcement")
                                                .putCustomAttribute("status", "success")
                                        );
                                    }
                                    @Override
                                    public void onErrorResponse(PojoError error) {
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
                        public void onErrorResponse(PojoError error) {
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
                PojoAnnouncementDetailed pojoResponse = (PojoAnnouncementDetailed)response;

                groupId = pojoResponse.getGroup().getId();
                groupName = pojoResponse.getGroup().getName();

                if(!currentGroup.groupIdIsSame(groupId)) {

                    GenericListener gotAllGroupDataListener = new GenericListener() {
                        @Override public void execute() {
                            getComments();
                            MeInfo meInfo = MeInfo.getInstance();
                            if(meInfo.getUserId() == creatorId || meInfo.getRankInCurrentGroup().getValue() >= Strings.Rank.MODERATOR.getValue() ){
                                button_delete.setVisibility(View.VISIBLE);
                                button_edit.setVisibility(View.VISIBLE);
                            }                            }
                    };

                    currentGroup.setGroup(getActivity(), groupId, groupName, gotAllGroupDataListener);
                }else{
                    getComments();
                }

                button_send.setVisibility(View.VISIBLE);
                textView_commentTitle.setVisibility(View.VISIBLE);
                box_comment.setVisibility(View.VISIBLE);

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
       // Manager.GroupManager.leftGroup();
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

        adapter = new CustomAdapter(getActivity(), R.layout.comment_item, listComment);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                ImageView imageView_popup = view.findViewById(R.id.imageView_popup);

                adapter.showMenu(getActivity(), EnumAT.ANNOUNCEMENTS, announcementId, adapter.getItem(i), imageView_popup, getFragmentManager().beginTransaction(), self);
            }
        });
    }

    @Override
    public void editComment(long commentId, String content) {
        super.editComment(commentId, content);

    }

    private void getComments(){
        CustomResponseHandler getComments_rh = new CustomResponseHandler() {
            @Override
            public void onPOJOResponse(Object response) {
                adapter.clear();
                listComment.clear();

                ArrayList<PojoComment> comments = (ArrayList<PojoComment>) response;

                CurrentMembersManager members = currentGroup.getMembersManager();
                if(comments.isEmpty()) {
                    textView_noContent.setVisibility(v.VISIBLE);
                }else {
                    for (PojoComment t : comments) {
                        Member member = members.getMember(t.getCreator().getId());

                        Strings.Rank rank = member.getRank();
                        String profilePic = member.getProfilePic();

                        listComment.add(new CommentItem(t.getId(), profilePic, rank, t.getCreator(), t.getContent()));
                    }

                    textView_noContent.setVisibility(v.INVISIBLE);
                }
                adapter.notifyDataSetChanged();
                sRefreshLayout.setRefreshing(false);
            }
            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                sRefreshLayout.setRefreshing(false);
            }
            @Override
            public void onErrorResponse(PojoError error) {
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

        MiddleMan.newRequest(new GetCommentSection(getActivity(), getComments_rh, Strings.Path.ANNOUNCEMENTS.toString(), announcementId));
    }

    private void getData(){
        MiddleMan.newRequest(new GetAT(getActivity(),rh, Strings.Path.ANNOUNCEMENTS, announcementId));
    }

}

