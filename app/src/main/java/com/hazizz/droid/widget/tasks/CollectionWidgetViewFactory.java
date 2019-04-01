package com.hazizz.droid.widget.tasks;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.RemoteViews;
import android.widget.RemoteViewsService;

import com.hazizz.droid.Communication.POJO.Response.CustomResponseHandler;
import com.hazizz.droid.Communication.POJO.Response.POJOerror;
import com.hazizz.droid.Communication.POJO.Response.getTaskPOJOs.POJOgetTask;
import com.hazizz.droid.Communication.Requests.GetTasksFromMeSync;
import com.hazizz.droid.Communication.Requests.Parent.Request;
import com.hazizz.droid.D8;
import com.hazizz.droid.Network;
import com.hazizz.droid.R;
import com.hazizz.droid.SharedPrefs;

import java.util.ArrayList;

import okhttp3.ResponseBody;
import retrofit2.Call;

import static com.hazizz.droid.widget.tasks.CollectionWidgetProvider.EXTRA_ITEM_POSITION;

public class CollectionWidgetViewFactory implements RemoteViewsService.RemoteViewsFactory {

   // private static final int ID_CONSTANT = 0x0101010;

    private static String contentInfo = "";

    private ArrayList<POJOgetTask> data;
    private Context mContext;

    CollectionWidgetViewFactory(Context context) {
        mContext = context;
        data = new ArrayList<POJOgetTask>();
    }
    @Override
    public void onCreate() {
       /* String[] titles = { "New Phones Released!", "Random App Makes $300 Million",
                "Google Glass Robots", "Arduino Used in Mobile", "Orioles Win World Series" };
        String[] authors = { "Phone Scoop", "Yahoo Marketing Department", "Cyborg Alliance",
                "Some Open Source Person", "Roch Kubatko" };
        String[] dates = { "Everyday", "June 20, 2012", "September 10, 2014", "August 9, 2014", "November 10, 2014" };

        for(int i = 0; i < 5; i++) {
            data.add(new POJOgetTask(1, "type", titles[i], "descripto", new POJOsubject(1, "asd"),
                    dates[i], new POJOcreator(1, "usernaem", "2"), new POJOgroup(1, "name", "OPen asd", 2)));
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

        POJOgetTask task = data.get(position);

        RemoteViews itemView = new RemoteViews(mContext.getPackageName(), R.layout.widget_task_item);

        itemView.setTextViewText(R.id.task_title, task.getTitle());
        itemView.setTextViewText(R.id.task_description, task.getDescription());
        itemView.setTextViewText(R.id.textView_creator, task.getCreator().getDisplayName());

        if(task.getSubject() != null) {
            itemView.setTextViewText(R.id.textView_subject, task.getSubject().getName());
        }else{
            itemView.setViewVisibility(R.id.textView_subject, View.INVISIBLE);
            itemView.setViewVisibility(R.id.textView_subject_info, View.INVISIBLE);
        }
        itemView.setTextViewText(R.id.textView_deadline, D8.textToDate(task.getDueDate()).getMainFormat());

        Intent intent = new Intent();
      //  intent.putExtra(CollectionWidgetProvider.EXTRA_ITEM, task);
        intent.putExtra(EXTRA_ITEM_POSITION, position);
        itemView.setOnClickFillInIntent(R.layout.widget_task_item, intent);

        final Intent fillInIntent = new Intent();
        fillInIntent.setAction(CollectionWidgetProvider.ACTION_TOAST);
        final Bundle bundle = new Bundle();
        bundle.putInt(CollectionWidgetProvider.EXTRA_STRING,
                position);
        fillInIntent.putExtras(bundle);
        itemView.setOnClickFillInIntent(R.id.task_title, fillInIntent);
        itemView.setOnClickFillInIntent(R.layout.widget_task_item, fillInIntent);
        itemView.setOnClickFillInIntent(R.id.widget_stack, fillInIntent);
        itemView.setOnClickFillInIntent(R.id.widget_item_linearLayout, fillInIntent);

        return itemView;
    }

    @Override public int getViewTypeCount() {
        return 2;
    }

    @Override public boolean hasStableIds() {
        return true;
    }

    @Override
    public void onDataSetChanged() {
        RemoteViews widgetView = new RemoteViews(mContext.getPackageName(), R.layout.hazizz_widget);
        if(Network.isConnectedOrConnecting(mContext)) {
            contentInfo = "";
            CustomResponseHandler rh = new CustomResponseHandler() {
                @Override
                public void onPOJOResponse(Object response) {
                    ArrayList<POJOgetTask> r = (ArrayList<POJOgetTask>) response;
                    if (r == null || r.isEmpty()) {
                        data.clear();
                        contentInfo = "Nincs feladat";
                    } else {
                        data = D8.sortTasksByDate(r);
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
                public void onErrorResponse(POJOerror error) {
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
                Request request = new GetTasksFromMeSync(mContext, rh);
                request.setupCall();
                request.makeCall();
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
}