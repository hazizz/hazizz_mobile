package com.indeed.hazizz.Fragments;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.TextView;

import com.crashlytics.android.answers.Answers;
import com.crashlytics.android.answers.CustomEvent;
import com.crashlytics.android.answers.SignUpEvent;
import com.indeed.hazizz.Activities.MainActivity;
import com.indeed.hazizz.AndroidThings;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CommentSectionPOJOs.POJOComment;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOMembersProfilePic;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.Strings;
import com.indeed.hazizz.Listviews.CommentList.CommentItem;
import com.indeed.hazizz.Listviews.CommentList.CustomAdapter;
import com.indeed.hazizz.Manager;
import com.indeed.hazizz.R;

import java.util.ArrayList;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.List;

import okhttp3.Headers;
import okhttp3.ResponseBody;
import retrofit2.Call;

public class CommentSectionFragment extends Fragment {
    private View v;
    private CustomAdapter adapter;
    private List<CommentItem> listComment;

    private int taskId, announcementId, groupId, subjectId;
    private String commentId;

    private EditText editText_commentBody;
    private ImageButton button_send;
    private TextView textView_noContent;
    private SwipeRefreshLayout sRefreshLayout;


    private CustomResponseHandler responseHandler = new CustomResponseHandler() {
        @Override
        public void onPOJOResponse(Object response) {
            ArrayList<POJOComment> comments = (ArrayList<POJOComment>) response;
            HashMap<Integer, POJOMembersProfilePic> profilePicMap = Manager.ProfilePicManager.getCurrentGroupMembersProfilePic();
            if(comments.isEmpty()) {
                textView_noContent.setVisibility(v.VISIBLE);
            }else {
                adapter.clear();
                for (POJOComment t : comments) {
                    listComment.add(new CommentItem(profilePicMap.get((int)t.getCreator().getId()).getData(), t.getCreator(), t.getContent()));
                }
                adapter.notifyDataSetChanged();
                textView_noContent.setVisibility(v.INVISIBLE);
            }
            sRefreshLayout.setRefreshing(false);
        }
        @Override
        public void onFailure(Call<ResponseBody> call, Throwable t) {
            Log.e("hey", "4");
            Log.e("hey", "got here onFailure");
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

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_commentsection, container, false);
        Log.e("hey", "main fragment created");

        commentId = getArguments().getString(Strings.Path.COMMENTID.toString());
        groupId = getArguments().getInt(Strings.Path.GROUPID.toString());
        subjectId = getArguments().getInt(Strings.Path.SUBJECTID.toString());
        taskId = getArguments().getInt(Strings.Path.TASKID.toString());
        announcementId = getArguments().getInt(Strings.Path.ANNOUNCEMENTID.toString());


        editText_commentBody = v.findViewById(R.id.editText_comment_body);
        textView_noContent = v.findViewById(R.id.textView_noContent);
        sRefreshLayout = v.findViewById(R.id.swipe_refresh_layout); sRefreshLayout.bringToFront();
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


                    EnumMap<Strings.Path, Object> vars = new EnumMap<>(Strings.Path.class);
                    if(taskId != 0){
                        vars.put(Strings.Path.TASKID, taskId);
                    }else{
                        vars.put(Strings.Path.ANNOUNCEMENTID, announcementId);
                    }if(groupId != 0){
                        vars.put(Strings.Path.GROUPID, groupId);
                    }else{
                        vars.put(Strings.Path.SUBJECTID, subjectId);
                    }
                    MiddleMan.newRequest(getActivity(), "addComment", body, new CustomResponseHandler() {
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
                    }, vars);
                }
            }
        });
        ((MainActivity)getActivity()).onFragmentCreated();
        createViewList();
        getComments();


        return v;
    }

    void createViewList(){
        listComment = new ArrayList<>();

        ListView listView = (ListView)v.findViewById(R.id.listView_comments);

        adapter = new CustomAdapter(getActivity(), R.layout.comment_item, listComment);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {

            }
        });
    }

    private void getComments(){
        adapter.clear();
        EnumMap<Strings.Path, Object> vars = new EnumMap<>(Strings.Path.class);

        vars.put(Strings.Path.TASKID, taskId);
        vars.put(Strings.Path.ANNOUNCEMENTID, announcementId);
        vars.put(Strings.Path.GROUPID, groupId);
        vars.put(Strings.Path.SUBJECTID, subjectId);

        MiddleMan.newRequest(this.getActivity(), "getCommentSection", null, responseHandler, vars);

    }
}
