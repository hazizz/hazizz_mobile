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
import android.widget.Spinner;
import android.widget.TextView;

import com.hazizz.droid.Communication.MiddleMan;
import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.Requests.RequestType.Thera.ThReturnSchedules.PojoClass;
import com.hazizz.droid.Communication.Requests.RequestType.Thera.ThReturnSchedules.ThReturnSchedules;
import com.hazizz.droid.D8;
import com.hazizz.droid.Fragments.ParentFragment.ParentFragment;
import com.hazizz.droid.Listviews.TheraReturnSchedules.ClassItem;
import com.hazizz.droid.Listviews.TheraReturnSchedules.CustomAdapter;
import com.hazizz.droid.R;
import com.hazizz.droid.SharedPrefs;
import com.hazizz.droid.Transactor;

import java.util.ArrayList;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class TheraSchedulesFragment extends ParentFragment {

    private CustomAdapter adapter;
    private List<ClassItem> listClassesAll = new ArrayList<>();

    private List<ClassItem> listClassesCurrentDay;

    private Spinner spinner_day_chooser;
    private TextView textView_spinner_display;

    private int currentDay;

    private String weekNumber;
    private String year;

    private final static int weekEndStart = 5;


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_th_timetable, container, false);
        Log.e("hey", "TheraSchedulesFragment fragment created");

        fragmentSetup(R.string.thera_schedules);

        currentDay = D8.getDayOfWeek()-1;
        if(currentDay >= weekEndStart){
            currentDay = 0;
        }
        spinner_day_chooser = v.findViewById(R.id.spinner_day_chooser);
        spinner_day_chooser.setSelection(currentDay);
        spinner_day_chooser.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                currentDay = position+1;
                getCurrentDaySchedules(currentDay);
                textView_spinner_display.setText(spinner_day_chooser.getSelectedItem().toString());
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        textView_spinner_display = v.findViewById(R.id.textView_spinner_display);


        weekNumber = D8.getWeek();
        year = D8.getYear();

        createViewList();
        getSchedules();
        return v;

    }
    void createViewList(){
        listClassesCurrentDay = new ArrayList<>();
        adapter = new CustomAdapter(getActivity(), R.layout.th_class_item, listClassesCurrentDay);
        ListView listView = (ListView)v.findViewById(R.id.listView_classes);
        listView.setAdapter(adapter);


        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                  Transactor.fragmentThDialogClass(getFragmentManager().beginTransaction(), adapter.getItem(i));
            }
        });



    }
    private void getSchedules(){
        CustomResponseHandler rh = new CustomResponseHandler() {
            @Override
            public void onPOJOResponse(Object response) {
                ArrayList<PojoClass> pojoList = (ArrayList<PojoClass>) response;
                if(pojoList.isEmpty()){
                }else {
                    String currentD = "";
                    for (PojoClass t : pojoList) {
                        if(t.getDate().equals(currentD)){
                            //Ehhez a naphoz tartozik
                        }else{
                            //Új nap

                        }
                        listClassesAll.add(new ClassItem(t.getDate(), t.getStartOfClass(), t.getEndOfClass(), t.getPeriodNumber(), t.isCancelled(), t.isStandIn(), t.getSubject(), t.getClassName(), t.getTeacher(), t.getRoom(), t.getTopic()));

                    }
                    getCurrentDaySchedules(currentDay);
                }
            }
            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {

            }
            @Override
            public void onErrorResponse(POJOerror error) {

            }
            @Override
            public void onNoConnection() {
                //   sRefreshLayout.setRefreshing(false);
            }
        };
        MiddleMan.newThRequest(new ThReturnSchedules(getActivity(),rh, SharedPrefs.ThSessionManager.getSessionId(getContext()), weekNumber, year));
    }

    private void getCurrentDaySchedules(int dayOfWeek){
        adapter.clear();
        int day = 0;
        String currentDate = "";
        for(ClassItem i : listClassesAll){
            if(!i.getDate().equals(currentDate)){
                day++;
                currentDate = i.getDate();
                if(dayOfWeek < day){
                    break;
                }
            }//else {continue;}
            if(dayOfWeek == day){
                listClassesCurrentDay.add(i);
                adapter.notifyDataSetChanged();
            }
        }
    }

}
