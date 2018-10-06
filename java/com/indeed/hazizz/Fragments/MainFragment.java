package com.indeed.hazizz.Fragments;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;

import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.POJO.Response.POJOgroup;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgetTask;
import com.indeed.hazizz.Listviews.TaskList.CustomAdapter;
import com.indeed.hazizz.Listviews.GroupList.GroupItem;
import com.indeed.hazizz.Listviews.TaskList.TaskItem;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class MainFragment extends Fragment {

    private View v;
    private CustomAdapter adapter;
    private List<TaskItem> listTask;
    private ArrayList<Integer> groupIDs;

    private int i = 0;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_main, container, false);
        Log.e("hey", "main fragment created");

        groupIDs = getArguments().getIntegerArrayList("groupIDs");

        createViewList();
        getTasks(groupIDs);

        return v;
    }

    void createViewList(){
        listTask = new ArrayList<>();

        ListView listView = (ListView)v.findViewById(R.id.listView2);

        adapter = new CustomAdapter(getActivity(), R.layout.task_item, listTask);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                // TODO
                HashMap<String, Object> vars = new HashMap<>();
                vars.put("taskId", ((TaskItem)listView.getItemAtPosition(i)).getTaskId());
                vars.put("groupId", ((TaskItem)listView.getItemAtPosition(i)).getGroupData().getId());
                Log.e("hey", "asd: " + vars.get("taskId") + ", " + vars.get("groupId"));

                Transactor.makeTransaction(new ViewTaskFragment(), getFragmentManager().beginTransaction(), vars);
            }
        });
    }

    private void getTasks(ArrayList<Integer> gIDs){
        Log.e("hey", "atleast here 2");
        CustomResponseHandler responseHandler = new CustomResponseHandler() {
            @Override
            public void onResponse(HashMap<String, Object> response) {

            }

            @Override
            public void onPOJOResponse(Object response) {
                ArrayList<POJOgetTask> casted = (ArrayList<POJOgetTask>) response;

                for(POJOgetTask t : casted) {
                    listTask.add(new TaskItem(R.drawable.ic_launcher_background, t.getTitle(),
                            t.getDescription(), t.getDueDate(), t.getGroupData(), t.getId()));
                    adapter.notifyDataSetChanged();
                    Log.e("hey", t.getId() + " " + t.getGroupData().getId());
                }

             /*   int size = ((ArrayList)response).size();
                for(int i = 0; i < size-1; i++) {
                    listTask.add(new TaskItem(R.drawable.ic_launcher_background, ((POJOgetTask) ((List) response).get(i)).getTitle(),
                            ((POJOgetTask) ((List) response).get(i)).getDescription(), ((POJOgetTask) ((List) response).get(i)).getDueDate()));
                    adapter.notifyDataSetChanged();
                } */
                Log.e("hey", "got response");
            }

            @Override
            public void onFailure() {
                Log.e("hey", "4");
                Log.e("hey", "got here onFailure");
            }

            @Override
            public void onErrorResponse(POJOerror error) {
                Log.e("hey", "onErrorResponse");
            }

            @Override
            public void onNoResponse(POJOerror error) {

            }
        };
        MiddleMan.newRequest(this.getActivity(), "getTasksFromMe", null, responseHandler, null);

    }
}
