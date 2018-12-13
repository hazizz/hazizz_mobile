package com.indeed.hazizz.Fragments.MainTab;

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

import com.indeed.hazizz.Activities.MainActivity;
import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgetTask;
import com.indeed.hazizz.D8;
import com.indeed.hazizz.Listviews.TaskList.Main.CustomAdapter;
import com.indeed.hazizz.Listviews.TaskList.TaskItem;
import com.indeed.hazizz.Manager;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class MainFragment extends Fragment {

    private View v;
    private CustomAdapter adapter;
    private List<TaskItem> listTask;
    private ArrayList<Integer> groupIDs;

    private TextView textView_noContent;
    private SwipeRefreshLayout sRefreshLayout;



    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_main, container, false);
        Log.e("hey", "main fragment created");



        textView_noContent = v.findViewById(R.id.textView_noContent);
        sRefreshLayout = (SwipeRefreshLayout) v.findViewById(R.id.swipe_refresh_layout); sRefreshLayout.bringToFront();
        sRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                getTasks();
            }});

        ((MainActivity)getActivity()).onFragmentCreated();
        createViewList();
        getTasks();

        return v;
    }

    void createViewList(){
        listTask = new ArrayList<>();

        ListView listView = (ListView)v.findViewById(R.id.listView2);


        adapter = new CustomAdapter(getActivity(), R.layout.task_main_item, listTask);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {

              /*  HashMap<String, Object> vars = new HashMap<>();
                vars.put("taskId", ((TaskItem)listView.getItemAtPosition(i)).getTaskId());
                vars.put("groupId", ((TaskItem)listView.getItemAtPosition(i)).getGroupData().getId()); */
             //   Log.e("hey", "asd: " + vars.get("taskId") + ", " + vars.get("groupId"));

                Transactor.fragmentViewTask(getFragmentManager().beginTransaction(),((TaskItem)listView.getItemAtPosition(i)).getGroupData().getId(),
                        ((TaskItem)listView.getItemAtPosition(i)).getTaskId(),
                        ((TaskItem)listView.getItemAtPosition(i)).getGroupData().getName(),
                        true, Manager.DestManager.TOMAIN);
            }
        });
    }

    private void getTasks(){
        adapter.clear();
        CustomResponseHandler responseHandler = new CustomResponseHandler() {
            @Override
            public void onResponse(HashMap<String, Object> response) { }
            @Override
            public void onPOJOResponse(Object response) {
                ArrayList<POJOgetTask> sorted = D8.sortTasksByDate((ArrayList<POJOgetTask>) response);


                if(sorted.size() == 0) {
                    textView_noContent.setVisibility(v.VISIBLE);
                }else {
                    textView_noContent.setVisibility(v.INVISIBLE);
                    for (POJOgetTask t : sorted) {
                        listTask.add(new TaskItem(R.drawable.ic_launcher_background, t.getTitle(),
                                t.getDescription(), t.getDueDate(), t.getGroupData(), t.getCreator(), t.getSubjectData(), t.getId()));
                        adapter.notifyDataSetChanged();
                    }
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
            public void onEmptyResponse() { }
            @Override
            public void onSuccessfulResponse() { }
            @Override
            public void onNoConnection() {
                textView_noContent.setText("Nincs internet kapcsolat");
                textView_noContent.setVisibility(View.VISIBLE);
                sRefreshLayout.setRefreshing(false);
            }
        };
        MiddleMan.newRequest(this.getActivity(), "getTasksFromMe", null, responseHandler, null);
    }
}
