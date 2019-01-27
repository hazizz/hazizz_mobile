package com.hazizz.droid.Fragments.MainTab;

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

import com.hazizz.droid.Activities.MainActivity;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.POJO.Response.getTaskPOJOs.POJOgetTask;
import com.hazizz.droid.D8;
import com.hazizz.droid.Listviews.TaskList.Main.CustomAdapter;
import com.hazizz.droid.Listviews.TaskList.TaskItem;
import com.hazizz.droid.Manager;
import com.hazizz.droid.Transactor;
import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.R;

import java.util.ArrayList;
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
                vars.put(Strings.Id.TASK.toString(), ((TaskItem)listView.getItemAtPosition(i)).getTaskId());
                vars.put(Strings.Id.GROUP.toString(), ((TaskItem)listView.getItemAtPosition(i)).getGroup().getId()); */
             //   Log.e("hey", "asd: " + vars.get("taskId") + ", " + vars.get("groupId"));
                int subjectId;
                if(((TaskItem)listView.getItemAtPosition(i)).getSubject() != null){
                    subjectId = ((TaskItem)listView.getItemAtPosition(i)).getSubject().getId();
                }else{subjectId=0;}

                Transactor.fragmentViewTask(getFragmentManager().beginTransaction(),((TaskItem)listView.getItemAtPosition(i)).getGroup().getId(),
                        subjectId, ((TaskItem)listView.getItemAtPosition(i)).getTaskId(),
                        ((TaskItem)listView.getItemAtPosition(i)).getGroup().getName(),
                        true, Manager.DestManager.TOMAIN);
            }
        });
    }

    private void getTasks(){
        adapter.clear();
        CustomResponseHandler responseHandler = new CustomResponseHandler() {
            @Override
            public void onPOJOResponse(Object response) {
                ArrayList<POJOgetTask> sorted = D8.sortTasksByDate((ArrayList<POJOgetTask>) response);

                if(sorted.isEmpty()) {
                    textView_noContent.setVisibility(v.VISIBLE);
                }else {
                    textView_noContent.setVisibility(v.INVISIBLE);
                    for (POJOgetTask t : sorted) {
                        listTask.add(new TaskItem(R.drawable.ic_launcher_background, t.getTitle(),
                                t.getDescription(), t.getDueDate(), t.getGroup(), t.getCreator(), t.getSubject(), t.getId()));
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
            public void onNoConnection() {
                textView_noContent.setText(R.string.info_noInternetAccess);
                textView_noContent.setVisibility(View.VISIBLE);
                sRefreshLayout.setRefreshing(false);
            }
        };
        MiddleMan.newRequest(this.getActivity(), "getTasksFromMe", null, responseHandler, null);
    }
}
