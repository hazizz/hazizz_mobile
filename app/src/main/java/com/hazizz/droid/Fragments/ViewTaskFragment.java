package com.hazizz.droid.Fragments;

import android.content.Context;
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
import android.view.ContextThemeWrapper;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.Spinner;
import android.widget.TextView;

import com.crashlytics.android.answers.Answers;
import com.crashlytics.android.answers.CustomEvent;
import com.hazizz.droid.Activities.MainActivity;
import com.hazizz.droid.AndroidThings;
import com.hazizz.droid.Communication.POJO.Response.CommentSectionPOJOs.POJOComment;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.GetUserPermissionInGroup;
import com.hazizz.droid.Communication.POJO.Response.POJOMembersProfilePic;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.POJO.Response.POJOsubject;
import com.hazizz.droid.Communication.POJO.Response.POJOuser;
import com.hazizz.droid.Communication.POJO.Response.PojoPermisionUsers;
import com.hazizz.droid.Communication.POJO.Response.PojoType;
import com.hazizz.droid.Communication.POJO.Response.getTaskPOJOs.POJOgetTaskDetailed;
import com.hazizz.droid.Communication.Requests.AddComment;
import com.hazizz.droid.Communication.Requests.DeleteAT;
import com.hazizz.droid.Communication.Requests.DeleteATComment;
import com.hazizz.droid.Communication.Requests.GetAT;
import com.hazizz.droid.Communication.Requests.GetCommentSection;
import com.hazizz.droid.Communication.Requests.GetGroupMemberPermisions;
import com.hazizz.droid.Communication.Requests.GetGroupMembersProfilePic;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.D8;
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

public class ViewTaskFragment extends Fragment implements AdapterView.OnItemSelectedListener{

   // private Button button_comments;
    private Button button_delete;
    private Button button_edit;


    private short enable_button_comment = 0;
    private int creatorId, groupId, taskId;
    private int subjectId = 0;

    public static final boolean myMode = true;
    public static final boolean publicMode = false;

    private boolean isMyMode;

    private String groupName;
    private PojoType type;
    private String subjectName;
    private String title;
    private String descripiton;
    private String date;

    private Spinner subject_spinner;

    private TextView textView_type;
    private TextView textView_title;
    private TextView textView_description;
    private TextView textView_creatorName;
    private TextView textView_subject;
    private TextView textView_group;
    private TextView textView_group_;
    private TextView textView_deadLine;

    private CustomResponseHandler getTask_rh;

    private ConstraintLayout constraintLayout;


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


    // Comment part
    private TextView textView_commentTitle;

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
                    listComment.add(new CommentItem(t.getId() ,profilePicMap.get((int)t.getCreator().getId()).getData(), t.getCreator(), t.getContent()));
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
        public void onEmptyResponse() {
            sRefreshLayout.setRefreshing(false);
        }
        @Override
        public void onNoConnection() {
            textView_noContent.setText(R.string.info_noInternetAccess);
            textView_noContent.setVisibility(View.VISIBLE);
            sRefreshLayout.setRefreshing(false);
        }
    };

    private POJOsubject subject;

    private boolean goBackToMain;
    private boolean gotResponse = false;

    private View v;

    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_viewtask, container, false);
        Log.e("hey", "im here lol");
        ((MainActivity)getActivity()).onFragmentCreated();
        getActivity().setTitle(R.string.title_fragment_view_task);
        textView_type = v.findViewById(R.id.textView_tasktype);
        textView_title = v.findViewById(R.id.textView_title);
        textView_description = v.findViewById(R.id.editText_description);
        textView_creatorName = v.findViewById(R.id.textView_creator_);
        textView_subject = v.findViewById(R.id.textView_subject);
        textView_group = v.findViewById(R.id.textView_group);
        textView_group_ = v.findViewById(R.id.textView_group_);
        textView_deadLine = v.findViewById(R.id.textview_deadline);
        textView_deadLine.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Transactor.fragmentDialogDateViewer(getFragmentManager().beginTransaction(), date);
            }
        });

        button_delete = v.findViewById(R.id.button_delete);
        button_edit = v.findViewById(R.id.button_edit);

      /*  ConstraintLayout.
        LinearLayout.LayoutParams listLayoutParams = new LinearLayout.LayoutParams(
                LayoutHeight, LinearLayout.LayoutParams.WRAP_CONTENT);
        view.setLayoutParams(listLayoutParams);
        */
        /*
        int h = getActivity().getWindowManager().getDefaultDisplay().getHeight();
        ConstraintLayout mainLayout = (ConstraintLayout) v.findViewById(R.id.constraintLayout);
        h = mainLayout.getHeight();
        ViewGroup.LayoutParams params = mainLayout.getLayoutParams();
        params.height = h;
        mainLayout.setLayoutParams(new LinearLayout.LayoutParams(params));
        */

        // Comment part

        //  android:fitsSystemWindows="true"
        scrollView = v.findViewById(R.id.scrollView);
        textView_commentTitle = v.findViewById(R.id.textView_commentTitle);
        textView_commentTitle.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new Handler().post(new Runnable() {
                    @Override
                    public void run() {
                        scrollView.smoothScrollTo(0, textView_commentTitle.getBottom());
                    }
                });
            }
        });
        editText_commentBody = v.findViewById(R.id.editText_comment_body);
        textView_noContent = v.findViewById(R.id.textView_noContent);
        sRefreshLayout = v.findViewById(R.id.swipe_refresh_layout); sRefreshLayout.bringToFront();
        sRefreshLayout.setOnRefreshListener(() -> getData());
        sRefreshLayout.setColorSchemeColors(getResources().getColor(R.color.colorPrimaryDarkBlue), getResources().getColor(R.color.colorPrimaryLightBlue), getResources().getColor(R.color.colorPrimaryDarkBlue));
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
                    }, Strings.Path.TASKS.toString(), taskId, commentBody));
                }
            }
        });

        button_delete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                CustomResponseHandler delete_rh = new CustomResponseHandler() {
                    @Override
                    public void onSuccessfulResponse() {
                        if(Manager.DestManager.getDest() == Manager.DestManager.TOGROUP) {
                            Transactor.fragmentGroupTask(getFragmentManager().beginTransaction(), Manager.GroupManager.getGroupId(), Manager.GroupManager.getGroupName());
                        } else{
                            Transactor.fragmentMainTask(getFragmentManager().beginTransaction());
                        }
                        Answers.getInstance().logCustom(new CustomEvent("delete task")
                                .putCustomAttribute("status", "success")
                        );
                    }
                    @Override
                    public void onErrorResponse(POJOerror error) {
                        button_delete.setEnabled(true);
                        Answers.getInstance().logCustom(new CustomEvent("delete task")
                                .putCustomAttribute("status", error.getErrorCode())
                        );
                    }
                };
                button_delete.setEnabled(false);

                MiddleMan.newRequest(new DeleteAT(getActivity(), delete_rh, Strings.Path.TASKS, taskId));

            }
        });

        button_edit.setOnClickListener(view -> {
            if(gotResponse) {
                Transactor.fragmentEditTask(getFragmentManager().beginTransaction(), groupId,
                        Manager.GroupManager.getGroupName(), taskId, type, subjectId, subjectName, title, descripiton, date,
                        Manager.DestManager.TOGROUP);
            }
        });
        /*
        button_comments = v.findViewById(R.id.button_comments);
        button_comments.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Transactor.fragmentCommentSection(getFragmentManager().beginTransaction(), Strings.Path.TASKS.toString(), taskId);

            }
        });
        */

        Bundle bundle = this.getArguments();
        if (bundle != null) {
            taskId = bundle.getInt(Strings.Path.TASKID.toString());

            isMyMode = bundle.getBoolean("mode");
            goBackToMain = bundle.getBoolean("goBackToMain");

        }else{Log.e("hey", "bundle is null");}
        getTask_rh = new CustomResponseHandler() {
            @Override
            public void onPOJOResponse(Object response) {

                POJOgetTaskDetailed pojoResponse = (POJOgetTaskDetailed) response;

                if(!isMyMode){
                    if (pojoResponse.getGroup() != null) {
                        groupName = pojoResponse.getGroup().getName();
                        groupId = pojoResponse.getGroup().getId();
                        Manager.GroupManager.setGroupId(groupId);
                        Manager.GroupManager.setGroupName(groupName);
                    }

                    CustomResponseHandler r1 = new CustomResponseHandler() {
                        @Override
                        public void onPOJOResponse(Object response) {
                            PojoPermisionUsers pojoPermisionUser = (PojoPermisionUsers) response;
                            if (pojoPermisionUser != null) {
                                if (pojoPermisionUser.getOWNER() != null) {
                                    for (POJOuser u : pojoPermisionUser.getOWNER()) {
                                        Manager.GroupRankManager.setRank(u.getId(), Strings.Rank.OWNER);
                                    }
                                }
                                if (pojoPermisionUser.getMODERATOR() != null) {
                                    for (POJOuser u : pojoPermisionUser.getMODERATOR()) {
                                        Manager.GroupRankManager.setRank(u.getId(), Strings.Rank.MODERATOR);
                                    }
                                }
                                if (pojoPermisionUser.getUSER() != null) {
                                    for (POJOuser u : pojoPermisionUser.getUSER()) {
                                        Manager.GroupRankManager.setRank(u.getId(), Strings.Rank.USER);
                                    }
                                }
                            }
                            enable_button_comment++;
                            visibleIfEnabled_comment_send();
                        }
                    };
                    MiddleMan.newRequest(new GetGroupMemberPermisions(getActivity(), r1, groupId));

                    creatorId = (int) pojoResponse.getCreator().getId();

                    MiddleMan.newRequest(new GetUserPermissionInGroup(getActivity(), permissionRh, groupId, (int) Manager.MeInfo.getId()));

                    if (Manager.ProfilePicManager.getCurrentGroupId() != groupId || Manager.DestManager.getDest() == Manager.DestManager.TOMAIN) {
                        CustomResponseHandler responseHandler = new CustomResponseHandler() {
                            @Override
                            public void onPOJOResponse(Object response) {
                                Manager.ProfilePicManager.setCurrentGroupMembersProfilePic((HashMap<Integer, POJOMembersProfilePic>) response, groupId);
                                getComments();
                                enable_button_comment++;
                                visibleIfEnabled_comment_send();
                            }
                        };
                        MiddleMan.newRequest(new GetGroupMembersProfilePic(getActivity(), responseHandler, groupId));
                    } else {
                        enable_button_comment++;
                        visibleIfEnabled_comment_send();
                    }
                }else{// is my task
                    sRefreshLayout.setRefreshing(false);
                    getActivity().setTitle(R.string.view_mytask);
                    textView_group_.setVisibility(View.GONE);
                    textView_group.setVisibility(View.GONE);
                    textView_commentTitle.setVisibility(View.INVISIBLE);
                }

                taskId = (int)pojoResponse.getId();
                type = pojoResponse.getType();
                subject = pojoResponse.getSubject();

                if(subject != null) {
                    subjectName = subject.getName();
                    subjectId = subject.getId();
                }else{
                    subjectName = getString(R.string.subject_none);
                }

                type = pojoResponse.getType();
                title = pojoResponse.getTitle();
                descripiton = pojoResponse.getDescription();
                date = pojoResponse.getDueDate();


                gotResponse = true;

                int typeId = (int)pojoResponse.getType().getId();

                String[] taskTypeArray = getResources().getStringArray(R.array.taskTypes);
                textView_type.setText(taskTypeArray[typeId-1]);


                textView_title.setText(title);
                textView_description.setText(descripiton);

                textView_creatorName.setText(pojoResponse.getCreator().getDisplayName());

                textView_subject.setText(subjectName);
                textView_group.setText(groupName);

                textView_deadLine.setText(D8.textToDate(date).getMainFormat());

            }
        };
        createViewList();
        getData();

        return v;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
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

    public int getGroupId(){ return groupId; }
    public String getGroupName(){ return groupName; }
    public boolean getGoBackToMain(){ return goBackToMain; }


    public void visibleIfEnabled_comment_send(){
        if(enable_button_comment > 1){
            button_send.setVisibility(View.VISIBLE);
            editText_commentBody.setVisibility(View.VISIBLE);
            textView_commentTitle.setVisibility(View.VISIBLE);
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
                long commentId = adapter.getItem(i).getCommentId();
                ImageView imageView_popup = view.findViewById(R.id.imageView_popup);
           //     Transactor.fragmentDialogShowUserDetailDialog(getFragmentManager().beginTransaction(), (long)adapter.getItem(i).getCreator().getId(), adapter.getItem(i).getCommentProfilePic());

                PopupMenu popup = new PopupMenu(getActivity(), imageView_popup);

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
                                }, Strings.Path.TASKS, taskId, commentId));
                                break;
                        }
                        popup.dismiss();

                        return false;
                    }
                });
                popup.show();

            }
        });
    }

    private void getComments(){
        if(!isMyMode) {
            MiddleMan.newRequest(new GetCommentSection(getActivity(), getComments_rh, Strings.Path.TASKS.toString(), taskId));
        }
    }

    private void getData(){
        MiddleMan.newRequest(new GetAT(getActivity(), getTask_rh, Strings.Path.TASKS, taskId));
    }
}
