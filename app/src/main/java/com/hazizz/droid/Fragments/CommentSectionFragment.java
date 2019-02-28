package com.hazizz.droid.Fragments;

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
import com.hazizz.droid.Activities.MainActivity;
import com.hazizz.droid.AndroidThings;
import com.hazizz.droid.Communication.POJO.Response.CommentSectionPOJOs.POJOComment;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOMembersProfilePic;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.Requests.AddComment;
import com.hazizz.droid.Communication.Requests.GetCommentSection;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Listviews.CommentList.CommentItem;
import com.hazizz.droid.Listviews.CommentList.CustomAdapter;
import com.hazizz.droid.Manager;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.R;
import com.hazizz.droid.Transactor;

import java.util.ArrayList;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class CommentSectionFragment extends Fragment {
    private View v;
    private CustomAdapter adapter;
    private List<CommentItem> listComment;


    private int whereId;
    private String whereName;


    private EditText editText_commentBody;
    private ImageButton button_send;
    private TextView textView_noContent;
    private SwipeRefreshLayout sRefreshLayout;


    private CustomResponseHandler responseHandler = new CustomResponseHandler() {
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
                    listComment.add(new CommentItem(t.getId(), profilePicMap.get((int)t.getCreator().getId()).getData(), rank, t.getCreator(), t.getContent()));
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
        @Override public void onErrorResponse(POJOerror error) {
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

        getActivity().setTitle(R.string.title_fragment_comments);

        whereId = getArguments().getInt(Strings.Path.WHEREID.toString());
        whereName = getArguments().getString(Strings.Path.WHERENAME.toString());

        editText_commentBody = v.findViewById(R.id.editText_comment_body);
        textView_noContent = v.findViewById(R.id.textView_noContent);
        sRefreshLayout = v.findViewById(R.id.swipe_refresh_layout); sRefreshLayout.bringToFront();
        sRefreshLayout.setOnRefreshListener(() -> getComments());sRefreshLayout.setColorSchemeColors(getResources().getColor(R.color.colorPrimaryDarkBlue), getResources().getColor(R.color.colorPrimaryLightBlue), getResources().getColor(R.color.colorPrimaryDarkBlue));

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
                    }, whereName, whereId, commentBody));
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
                Transactor.fragmentDialogShowUserDetailDialog(getFragmentManager().beginTransaction(), (long)adapter.getItem(i).getCreator().getId(), adapter.getItem(i).getGroupRank().getValue(), adapter.getItem(i).getCommentProfilePic());
            }
        });
    }

    private void getComments(){
        MiddleMan.newRequest(new GetCommentSection(getActivity(), responseHandler, whereName, whereId));
    }
}
