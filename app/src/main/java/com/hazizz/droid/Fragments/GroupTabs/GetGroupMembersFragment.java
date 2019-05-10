package com.hazizz.droid.fragments.GroupTabs;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.FragmentManager;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.hazizz.droid.cache.CurrentGroup;
import com.hazizz.droid.cache.Member;
import com.hazizz.droid.communication.responsePojos.PojoMembersProfilePic;
import com.hazizz.droid.fragments.ParentFragment.TabFragment;
import com.hazizz.droid.listviews.UserList.CustomAdapter;
import com.hazizz.droid.listviews.UserList.UserItem;
import com.hazizz.droid.R;
import com.hazizz.droid.navigation.Transactor;

import java.util.ArrayList;
import java.util.List;

public class GetGroupMembersFragment extends TabFragment {

    private List<UserItem> listUser;
    private View v;
    private CustomAdapter adapter;
    private int groupId;
    private List<PojoMembersProfilePic> userProfilePics = new ArrayList<PojoMembersProfilePic>();

    private TextView textView_noContent;
    private SwipeRefreshLayout sRefreshLayout;

    private CurrentGroup currentGroup;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_getgroupmembers, container, false);

        fragmentSetup();

        groupId = GroupTabFragment.groupId;
        textView_noContent = v.findViewById(R.id.textView_noContent);

        sRefreshLayout = v.findViewById(R.id.swipe_refresh_layout);
        sRefreshLayout.bringToFront();
        sRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                getUsers();
            }});
        sRefreshLayout.setColorSchemeColors(getResources().getColor(R.color.colorPrimaryDarkBlue), getResources().getColor(R.color.colorPrimaryLightBlue), getResources().getColor(R.color.colorPrimaryDarkBlue));

        currentGroup = CurrentGroup.getInstance();
        createViewList();
        if(!isViewShown) {
            getUsers();
            isViewShown = true;
        }
        return v;
    }

    public void getUsers() {
        List<Member> members =  currentGroup.getMembers();
        listUser.clear();
        for(Member member : members) {
            listUser.add(new UserItem(member.getUserId(), member.getDisplayName(), member.getUsername(), member.getProfilePic(), member.getRank().getValue()));
        }
        adapter.notifyDataSetChanged();
        sRefreshLayout.setRefreshing(false);
    }

    void createViewList(){
        listUser = new ArrayList<>();

        ListView listView = (ListView)v.findViewById(R.id.listView_getGroupMembers);

        adapter = new CustomAdapter(getActivity(), R.layout.user_item, listUser);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                Transactor.fragmentDialogShowUserDetailDialog(getFragmentManager().beginTransaction(), adapter.getItem(i).getId(), adapter.getItem(i).getUserRank(),
                        adapter.getItem(i).getUserProfilePic());
                        // Manager.ProfilePicManager.getCurrentGroupMembersProfilePic().get((int)adapter.getItem(i).getId()).getData());
            }
        });
    }

    public void openInviteLinkDialog(FragmentManager fm){
        Transactor.fragmentDialogInviteLink(fm.beginTransaction(), GroupTabFragment.groupId, GroupTabFragment.groupName);
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (getView() != null && !isViewShown) {
            isViewShown = true;
            getUsers();
        } else {
            isViewShown = false;
        }
    }
}
