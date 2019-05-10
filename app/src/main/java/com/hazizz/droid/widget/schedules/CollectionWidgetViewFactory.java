package com.hazizz.droid.widget.schedules;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.RemoteViews;
import android.widget.RemoteViewsService;



import com.hazizz.droid.communication.requests.parent.ThRequest;
import com.hazizz.droid.communication.requests.RequestType.Thera.ThReturnSchedules.ThReturnSchedules;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.PojoError;
import com.hazizz.droid.other.D8;
import com.hazizz.droid.listviews.TheraReturnSchedules.ClassItem;
import com.hazizz.droid.other.Network;
import com.hazizz.droid.R;
import com.hazizz.droid.other.SharedPrefs;

import java.util.ArrayList;

import okhttp3.ResponseBody;
import retrofit2.Call;

import static com.hazizz.droid.widget.schedules.CollectionWidgetProvider.EXTRA_ITEM_POSITION;

public class CollectionWidgetViewFactory implements RemoteViewsService.RemoteViewsFactory {

   // private static final int ID_CONSTANT = 0x0101010;

    private static int currentDay;
    private static int weekNumber;
    private static int year;

    private static final int weekEndStart = 5;

    private static String contentInfo = "";

    private ArrayList<ClassItem> data;

    private ArrayList<ClassItem> listClassesAll = new ArrayList<>();

    private Context mContext;

    CollectionWidgetViewFactory(Context context) {
        mContext = context;
        data = new ArrayList<>();
    }

    private void initDate(){
        currentDay = D8.getDayOfWeek(D8.getNow())-1;
        if(currentDay >= weekEndStart){
            currentDay = 0;
        }
    }

    private void getCurrentDaySchedules(int dayOfWeek){
        data.clear();
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
                data.add(i);
            }
        }
    }

    @Override
    public void onCreate() {
        initDate();
        Log.e("hey", "OnCreate");
       /* String[] titles = { "New Phones Released!", "Random App Makes $300 Million",
                "Google Glass Robots", "Arduino Used in Mobile", "Orioles Win World Series" };
        String[] authors = { "Phone Scoop", "Yahoo Marketing Department", "Cyborg Alliance",
                "Some Open Source Person", "Roch Kubatko" };
        String[] dates = { "Everyday", "June 20, 2012", "September 10, 2014", "August 9, 2014", "November 10, 2014" };

        for(int i = 0; i < 5; i++) {
            data.add(new  PojoTask(1, "type", titles[i], "descripto", new  PojoAuth(1, "asd"),
                    dates[i], new PojoCreator(1, "usernaem", "2"), new PojoGroup(1, "name", "OPen asd", 2)));
        } */
    }

    @Override public int getCount() {
        return data.size();
    }
    @Override public long getItemId(int position) {
        return position;//ID_CONSTANT + position;
    }
    @Override public RemoteViews getLoadingView() {
        return null;
    }
    @Override
    public RemoteViews getViewAt(int position) {

        ClassItem task = data.get(position);

        RemoteViews itemView = new RemoteViews(mContext.getPackageName(), R.layout.item_widget_thera_schedule);

        itemView.setTextViewText(R.id.task_title, task.getPeriodNumber() + ".");
        itemView.setTextViewText(R.id.task_description, task.getClassName());
     //   itemView.setTextViewText(R.id.textView_creator_, task.getCreator().getDisplayName());

        /*
        if(task.getSubject() != null) {
            itemView.setTextViewText(R.id.textView_subject, task.getSubject().getName());
        }else{
            itemView.setViewVisibility(R.id.textView_subject, View.INVISIBLE);
            itemView.setViewVisibility(R.id.textView_subject_info, View.INVISIBLE);
        }
        itemView.setTextViewText(R.id.textView_deadline, task.getDueDate());
        */

        Intent intent = new Intent();
      //  intent.putExtra(CollectionWidgetProvider.EXTRA_ITEM, task);
        intent.putExtra(EXTRA_ITEM_POSITION, position);
        itemView.setOnClickFillInIntent(R.layout.item_widget_thera_schedule, intent);



        final Intent fillInIntent = new Intent();
        fillInIntent.setAction(CollectionWidgetProvider.ACTION_TOAST);
        final Bundle bundle = new Bundle();
        bundle.putInt(CollectionWidgetProvider.EXTRA_STRING,
                position);
        fillInIntent.putExtras(bundle);
        itemView.setOnClickFillInIntent(R.id.task_title, fillInIntent);
        itemView.setOnClickFillInIntent(R.layout.widget_task_item, fillInIntent);
        itemView.setOnClickFillInIntent(R.id.widget_list, fillInIntent);
        itemView.setOnClickFillInIntent(R.id.widget_item_linearLayout, fillInIntent);




        return itemView;
    }

    @Override public int getViewTypeCount() {
        return 1;
    }

    @Override public boolean hasStableIds() {
        return true;
    }

    @Override
    public void onDataSetChanged() {
        RemoteViews widgetView = new RemoteViews(mContext.getPackageName(), R.layout.widget_thera_schedules);
        if(Network.isConnectedOrConnecting(mContext)) {
            contentInfo = "";
            CustomResponseHandler rh = new CustomResponseHandler() {
                @Override
                public void onPOJOResponse(Object response) {
                    listClassesAll = (ArrayList<ClassItem>) response;

                    if (listClassesAll == null || listClassesAll.isEmpty()) {
                        data.clear();
                        contentInfo = "Nincs feladat";
                    } else {
                      //  data = D8.sortTasksByDate(r);
                        contentInfo = "";
                    }
                    Log.e("hey", "pojo response");
                }
                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
                    Log.e("hey", "timeout maybe");
                    contentInfo = "";
                }
                @Override
                public void onErrorResponse(PojoError error) {
                    if(error.getErrorCode() == 17) {
                        data.clear();
                        contentInfo = "Nem vagy bejelentkezve";
                    }else{
                        data.clear();
                        contentInfo ="Nem sikerült betölteni";
                    }
                }
            };

            if (!SharedPrefs.TokenManager.getToken(mContext).equals("")) {
                ThRequest request = new ThReturnSchedules(mContext, rh, SharedPrefs.ThSessionManager.getSessionId(mContext), weekNumber, year);
                request.setupCall();
                request.makeAsyncCall();
            } else {
                data.clear();
                contentInfo = "Nem vagy bejelentkezve";
            }
        }else{
            contentInfo = "";
        }
        Log.e("hey", "onDataSetChanged called");
    }

    @Override
    public void onDestroy() {
        data.clear();
    }

    public static String getContentInfo(){
        return contentInfo;
    }

    public static void moveLeft(){

    }




}