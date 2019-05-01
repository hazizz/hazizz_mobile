package com.hazizz.droid.fragments.MainTab;

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
import android.widget.ListView;
import android.widget.TextView;

import com.hazizz.droid.activities.MainActivity;
import com.hazizz.droid.cache.HCache;

import com.hazizz.droid.Communication.requests.GetTasksFromMe;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.Communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.Communication.responsePojos.PojoError;
import com.hazizz.droid.Communication.responsePojos.taskPojos.PojoTask;
import com.hazizz.droid.other.D8;
import com.hazizz.droid.fragments.ViewTaskFragment;
import com.hazizz.droid.listviews.HeaderItem;
import com.hazizz.droid.listviews.TaskList.Main.CustomAdapter;
import com.hazizz.droid.listviews.TaskList.TaskItem;
import com.hazizz.droid.navigation.Transactor;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.R;

import java.util.ArrayList;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class MainFragment extends Fragment {

    private View v;
    private CustomAdapter adapter;
    private List<Object> itemList;

    private TextView textView_noContent;
    private SwipeRefreshLayout sRefreshLayout;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_main, container, false);
        Log.e("hey", "main task fragment created");

        textView_noContent = v.findViewById(R.id.textView_noContent);
        sRefreshLayout = (SwipeRefreshLayout) v.findViewById(R.id.swipe_refresh_layout); sRefreshLayout.bringToFront();
        sRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                getTasks();
            }});
        sRefreshLayout.setColorSchemeColors(getResources().getColor(R.color.colorPrimaryDarkBlue), getResources().getColor(R.color.colorPrimaryLightBlue), getResources().getColor(R.color.colorPrimaryDarkBlue));
        ((MainActivity)getActivity()).onFragmentCreated();
        createViewList();
        getTasks();

        processData(HCache.getInstance()
                .getTasksFromMe(getContext()));

        return v;
    }

    void createViewList(){
        itemList = new ArrayList<>();

        ListView listView = (ListView)v.findViewById(R.id.listView2);

        adapter = new CustomAdapter(getActivity(), itemList);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                Object item = listView.getItemAtPosition(i);
                if(item instanceof TaskItem){
                    boolean mode;
                    TaskItem taskItem = (TaskItem)item;
                    if(taskItem.getGroup() != null){
                        mode = ViewTaskFragment.publicMode;
                    }else{
                        mode = ViewTaskFragment.myMode;
                    }
                    Transactor.fragmentViewTask(getFragmentManager().beginTransaction(),
                            taskItem.getTaskId(),
                            true, Strings.Dest.TOMAIN, mode);
                }
            }
        });
    }

    private void processData(List<PojoTask> data){
        if(data != null) {
            adapter.clear();
            if (data.isEmpty()) {
                textView_noContent.setVisibility(v.VISIBLE);
            } else {
                textView_noContent.setVisibility(v.INVISIBLE);
                int lastDaysLeft = -1;
                for ( PojoTask t : data) {
                    String date = t.getDueDate();
                    int daysLeft = D8.textToDate(date).daysLeft();
                    if (daysLeft > lastDaysLeft) {
                        itemList.add(new HeaderItem(date));
                        lastDaysLeft = daysLeft;
                    }
                    itemList.add(new TaskItem(R.drawable.ic_launcher_background, t.getTitle(),
                            t.getDescription(), t.getGroup(), t.getCreator(), t.getSubject(), t.getId()));
                }
                adapter.notifyDataSetChanged();
            }
            sRefreshLayout.setRefreshing(false);
        }
    }

    private void getTasks(){
        CustomResponseHandler responseHandler = new CustomResponseHandler() {
            @Override public void getRawResponseBody(String rawResponseBody) {
                HCache.getInstance().setTasksFromMe(getContext(), rawResponseBody);
            }
            @Override
            public void onPOJOResponse(Object response) {
                ArrayList< PojoTask> sortedData = D8.sortTasksByDate((ArrayList< PojoTask>) response);
                processData(sortedData);
            }
            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                sRefreshLayout.setRefreshing(false);
            }
            @Override
            public void onErrorResponse(PojoError error) {
                sRefreshLayout.setRefreshing(false);
            }
            @Override
            public void onNoConnection() {
                textView_noContent.setText(R.string.info_noInternetAccess);
                textView_noContent.setVisibility(View.VISIBLE);
                sRefreshLayout.setRefreshing(false);
            }
        };
        MiddleMan.newRequest(new GetTasksFromMe(getActivity(), responseHandler));
    }
}
