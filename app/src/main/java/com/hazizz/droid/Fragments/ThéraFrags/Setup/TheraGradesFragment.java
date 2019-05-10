package com.hazizz.droid.fragments.ThéraFrags.Setup;

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

import com.hazizz.droid.cache.HCache;
import com.hazizz.droid.communication.MiddleMan;


import com.hazizz.droid.communication.requests.RequestType.Thera.ThReturnGrades.ThReturnGrades;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoError;
import com.hazizz.droid.fragments.ParentFragment.ParentFragment;
import com.hazizz.droid.listeners.OnBackPressedListener;
import com.hazizz.droid.listviews.TheraGradesList.TheraGradesItem;
import com.hazizz.droid.listviews.TheraGradesList.CustomAdapter;
import com.hazizz.droid.listviews.TheraGradesList.TheraSubjectGradesItem;
import com.hazizz.droid.R;
import com.hazizz.droid.other.SharedPrefs;
import com.hazizz.droid.navigation.Transactor;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;

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
        setOnBackPressedListener(new OnBackPressedListener() {
            @Override
            public void onBackPressed() {
                Transactor.fragmentThMain(getFragmentManager().beginTransaction());
            }
        });

        textView_noContent = v.findViewById(R.id.textView_noContent);
        createViewList();
        getGrades();

        processData(HCache.getInstance().getThera().getGrades(getContext()));

        return v;
    }
    void createViewList(){
        listGrades = new ArrayList<>();
        ListView listView = (ListView)v.findViewById(R.id.listView_classes);
        adapter = new CustomAdapter(getActivity(), R.layout.th_grade_subject_item, listGrades, getFragmentManager());
        listView.setAdapter(adapter);


        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
              //  Transactor.fragmentThDialogGrade(getFragmentManager().beginTransaction(), adapter.getItem(i));
            }
        });

    }


    private void processData(SortedMap<String, List<TheraGradesItem>> gradeMap){
        if(gradeMap != null) {
            if (gradeMap.isEmpty()) {
                textView_noContent.setVisibility(v.VISIBLE);
                Log.e("hey", "is Empty");
            } else {
                adapter.clear();
                textView_noContent.setVisibility(v.INVISIBLE);
                for (Map.Entry<String, List<TheraGradesItem>> entry : gradeMap.entrySet()) {
                    listGrades.add(new TheraSubjectGradesItem(entry.getKey(), entry.getValue()));
                    adapter.notifyDataSetChanged();
                    Log.e("hey", "iterate2");
                }
            }
        }
    }

    private void getGrades(){
        long sessionId = SharedPrefs.ThSessionManager.getSessionId(getContext());
        CustomResponseHandler responseHandler = new CustomResponseHandler() {
            @Override
            public void getRawResponseBody(String rawResponseBody) {
                HCache.getInstance().getThera().setGrades(getContext(), rawResponseBody);
            }

            @Override
            public void onPOJOResponse(Object response) {
                TreeMap<String, List<TheraGradesItem>> gradeMap = (TreeMap<String, List<TheraGradesItem>>)response;
                processData(gradeMap);
            }
            @Override
            public void onErrorResponse(PojoError error) {
                //        session not found,                session not active
                if(error.getErrorCode() == 132 || error.getErrorCode() == 136) {
                    Transactor.fragmentThLoginAuthSession(getFragmentManager().beginTransaction(), sessionId,
                            SharedPrefs.ThLoginData.getSchool(getContext(), sessionId),
                            SharedPrefs.ThLoginData.getUsername(getContext(), sessionId));
                }
            }
            @Override
            public void onNoConnection() {
                textView_noContent.setText(R.string.info_noInternetAccess);
                textView_noContent.setVisibility(View.VISIBLE);
            }
        };
        MiddleMan.newRequest(new ThReturnGrades(getActivity(),responseHandler, sessionId));
    }
}
