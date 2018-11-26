package com.indeed.hazizz.Fragments.GroupTabs;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.indeed.hazizz.Activities.MainActivity;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.AnnouncementPOJOs.POJOAnnouncement;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Listviews.AnnouncementList.AnnouncementItem;
import com.indeed.hazizz.Listviews.AnnouncementList.CustomAdapter;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class GroupAnnouncementFragment extends Fragment{

    private View v;
    private CustomAdapter adapter;
    private List<AnnouncementItem> listAnnouncement;

    private TextView textView_noContent;

    private int groupId;
    private String groupName;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_announcements, container, false);
        Log.e("hey", "announcement group fragment created");
        ((MainActivity)getActivity()).onFragmentCreated();
        groupId = getArguments().getInt("groupId");
        groupName = getArguments().getString("groupName");

        textView_noContent = v.findViewById(R.id.textView_noContent);
      //  ((MainActivity)getActivity()).setGroupName(groupName);
        createViewList();
        getAnnouncements();

        return v;
    }
    void createViewList(){
        listAnnouncement = new ArrayList<>();
        ListView listView = (ListView)v.findViewById(R.id.listView_announcementGroup);
        adapter = new CustomAdapter(getActivity(), R.layout.announcement_item, listAnnouncement);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                groupName = ((AnnouncementItem)listView.getItemAtPosition(i)).getGroupData().getName();
                    Transactor.fragmentViewAnnouncement(getFragmentManager().beginTransaction(),
                        ((AnnouncementItem)listView.getItemAtPosition(i)).getGroupData().getId(),
                        ((AnnouncementItem)listView.getItemAtPosition(i)).getAnnouncementId(),
                        ((AnnouncementItem)listView.getItemAtPosition(i)).getGroupData().getName(), false);
            }
        });
    }
    private void getAnnouncements(){
        CustomResponseHandler responseHandler = new CustomResponseHandler() {
            @Override
            public void onResponse(HashMap<String, Object> response) { }
            @Override
            public void onPOJOResponse(Object response) {
                ArrayList<POJOAnnouncement> pojoList = (ArrayList<POJOAnnouncement>) response;
                if(pojoList.size() == 0){
                    textView_noContent.setVisibility(v.VISIBLE);
                }else {
                    for (POJOAnnouncement t : pojoList) {
                        listAnnouncement.add(new AnnouncementItem(t.getTitle(),
                                t.getDescription(), t.getGroupData(), t.getCreator(), t.getSubjectData(), t.getId()));
                        adapter.notifyDataSetChanged();
                        Log.e("hey", t.getId() + " " + t.getGroupData().getId());
                    }
                    Log.e("hey", "got response");
                }
            }
            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                Log.e("hey", "4");
                Log.e("hey", "got here onFailure");
                textView_noContent.setVisibility(v.VISIBLE);
            }
            @Override
            public void onErrorResponse(POJOerror error) {
                Log.e("hey", "onErrorResponse");
            }
            @Override
            public void onEmptyResponse() {}
            @Override
            public void onSuccessfulResponse() { }
            @Override
            public void onNoConnection() {
                textView_noContent.setText("Nincs internet kapcsolat");
            }
        };
        HashMap<String, Object> vars = new HashMap<>();
        vars.put("groupId", Integer.toString(groupId));
        //  MiddleMan.request.getTasksFromGroup(this.getActivity(), null, responseHandler, vars);
        MiddleMan.newRequest(this.getActivity(),"getAnnouncementsFromGroup", null, responseHandler, vars);
    }

    public void toCreateAnnouncement(FragmentManager fm){
        groupId = getArguments().getInt("groupId");
        groupName = getArguments().getString("groupName");
        Transactor.fragmentCreateAnnouncement(fm.beginTransaction(),groupId, groupName);

    }
}


