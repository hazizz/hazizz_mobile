package com.hazizz.droid.Fragments;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;
import com.hazizz.droid.Activities.MainActivity;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.POJO.Response.getTaskPOJOs.POJOgetTask;
import com.hazizz.droid.Communication.Requests.GetMyTasks;
import com.hazizz.droid.Communication.Strings;
import com.hazizz.droid.D8;
import com.hazizz.droid.Listviews.HeaderItem;
import com.hazizz.droid.Listviews.TaskList.Main.CustomAdapter;
import com.hazizz.droid.Listviews.TaskList.TaskItem;
import com.hazizz.droid.Transactor;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.R;

import java.util.ArrayList;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class MyTasksFragment extends Fragment{

    private View v;
    private CustomAdapter adapter;
    private List<Object> itemList;

    private TextView textView_noContent;
    private SwipeRefreshLayout sRefreshLayout;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_main, container, false);

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

        getActivity().setTitle(R.string.my_tasks);

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
                    Transactor.fragmentViewTask(getFragmentManager().beginTransaction(),
                            ((TaskItem) item).getTaskId(),
                            true, Strings.Dest.TOMAIN, ViewTaskFragment.myMode);
                }
            }
        });
    }

    private void getTasks(){
        CustomResponseHandler responseHandler = new CustomResponseHandler() {
            @Override
            public void onPOJOResponse(Object response) {
                adapter.clear();
                ArrayList<POJOgetTask> sorted = D8.sortTasksByDate((ArrayList<POJOgetTask>) response);

                if(sorted.isEmpty()) {
                    textView_noContent.setVisibility(v.VISIBLE);
                }else {
                    textView_noContent.setVisibility(v.INVISIBLE);
                    int lastDaysLeft = -1;
                    for (POJOgetTask t : sorted) {
                        String date = t.getDueDate();
                        int daysLeft = D8.textToDate(date).daysLeft();

                        if(daysLeft > lastDaysLeft) {
                            itemList.add(new HeaderItem(date));
                            lastDaysLeft = daysLeft;
                        }
                        itemList.add(new TaskItem(R.drawable.ic_launcher_background, t.getTitle(),
                                t.getDescription(), t.getGroup(), t.getCreator(), t.getSubject(), t.getId()));
                        adapter.notifyDataSetChanged();
                    }
                }
                sRefreshLayout.setRefreshing(false);
            }
            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                sRefreshLayout.setRefreshing(false);
            }
            @Override
            public void onErrorResponse(POJOerror error) {
                sRefreshLayout.setRefreshing(false);
            }
            @Override
            public void onNoConnection() {
                textView_noContent.setText(R.string.info_noInternetAccess);
                textView_noContent.setVisibility(View.VISIBLE);
                sRefreshLayout.setRefreshing(false);
            }
        };
        MiddleMan.newRequest(new GetMyTasks(getActivity(), responseHandler));
    }

    public void toCreateTask(){
        Transactor.fragmentCreateMyTask(getFragmentManager().beginTransaction());
    }
}
