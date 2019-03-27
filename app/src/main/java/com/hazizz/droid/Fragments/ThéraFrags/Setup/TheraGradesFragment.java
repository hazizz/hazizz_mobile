package com.hazizz.droid.Fragments.ThéraFrags.Setup;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.Requests.RequestType.Thera.ThReturnGrades.ThReturnGrades;
import com.hazizz.droid.Fragments.ParentFragment.ParentFragment;
import com.hazizz.droid.Listviews.TheraGradesList.TheraGradesItem;
import com.hazizz.droid.Listviews.TheraGradesList.CustomAdapter;
import com.hazizz.droid.Listviews.TheraGradesList.TheraSubjectGradesItem;
import com.hazizz.droid.R;
import com.hazizz.droid.SharedPrefs;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TheraGradesFragment  extends ParentFragment {

    private CustomAdapter adapter;
    private List<TheraSubjectGradesItem> listGrades;

    private TextView textView_noContent;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_th_grades, container, false);
        Log.e("hey", "TheraGradesFragment fragment created");

        fragmentSetup(R.string.thera_grades);


        textView_noContent = v.findViewById(R.id.textView_noContent);
        createViewList();
        getGrades();

        return v;
    }
    void createViewList(){
        listGrades = new ArrayList<>();
        ListView listView = (ListView)v.findViewById(R.id.listView_classes);
        adapter = new CustomAdapter(getActivity(), R.layout.th_grade_subject_item, listGrades, getFragmentManager());
        //        adapter = new CustomAdapter(getActivity(), R.layout.th_grade_subject_item, listGrades, getFragmentManager().beginTransaction());
        listView.setAdapter(adapter);


        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
              //  Transactor.fragmentThDialogGrade(getFragmentManager().beginTransaction(), adapter.getItem(i));
            }
        });

    }
    private void getGrades(){
        CustomResponseHandler responseHandler = new CustomResponseHandler() {
            @Override
            public void onPOJOResponse(Object response) {
                adapter.clear();
                HashMap<String, List<TheraGradesItem>> pojoMap = (HashMap<String, List<TheraGradesItem>>)response;



                if(pojoMap.isEmpty()){
                    textView_noContent.setVisibility(v.VISIBLE);
                    Log.e("hey", "is Empty");
                }else {
                    textView_noContent.setVisibility(v.INVISIBLE);

                    for (Map.Entry<String,List<TheraGradesItem>> entry : pojoMap.entrySet()) {
                        listGrades.add(new TheraSubjectGradesItem(entry.getKey(), entry.getValue()));
                        adapter.notifyDataSetChanged();
                        Log.e("hey", "iterate2");
                    }
                }
            }
            @Override
            public void onErrorResponse(POJOerror error) {

            }
            @Override
            public void onNoConnection() {
                textView_noContent.setText(R.string.info_noInternetAccess);
                textView_noContent.setVisibility(View.VISIBLE);
                //   sRefreshLayout.setRefreshing(false);
            }
        };
        MiddleMan.newThRequest(new ThReturnGrades(getActivity(),responseHandler, SharedPrefs.ThSessionManager.getSessionId(getContext())));
    }
}
