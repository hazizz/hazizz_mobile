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

import com.indeed.hazizz.Communication.POJO.Response.POJOgroup;
import com.indeed.hazizz.Listviews.GroupList.CustomAdapter;
import com.indeed.hazizz.Listviews.GroupList.GroupItem;
import com.indeed.hazizz.R;
import com.indeed.hazizz.Transactor;

import java.util.ArrayList;
import java.util.List;

public class MainFragment extends Fragment {

    private View v;
    private CustomAdapter adapter;
    private List<GroupItem> listTask;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_main, container, false);
        Log.e("hey", "main fragment created");

        createViewList();
        getTasks();

        return v;
    }

    void createViewList(){
        listTask = new ArrayList<>();

        ListView listView = (ListView)v.findViewById(R.id.listView1);

        adapter = new CustomAdapter(getActivity(), R.layout.list_item, listTask);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                Transactor.makeTransaction(new CreateTaskFragment(), getFragmentManager().beginTransaction());
            }
        });
    }

    private void getTasks(){

    }
}
