package com.indeed.hazizz;

import android.appwidget.AppWidgetManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.View;
import android.widget.RemoteViews;
import android.widget.RemoteViewsService;

import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgetTask;
import com.indeed.hazizz.Communication.Requests.Request;

import java.util.ArrayList;
import java.util.HashMap;
//import com.indeed.hazizz.CollectionWidgetProvider

import okhttp3.ResponseBody;
import retrofit2.Call;

public class CollectionWidgetViewFactory implements RemoteViewsService.RemoteViewsFactory {

    private static final int ID_CONSTANT = 0x0101010;

    private ArrayList<POJOgetTask> data;
    private Context mContext;

    public CollectionWidgetViewFactory(Context context) {
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
            data.add(new POJOgetTask(1, "type", titles[i], "descripto", new POJOsubjectData(1, "asd"),
                    dates[i], new POJOcreator(1, "usernaem", "2"), new POJOgroupData(1, "name", "OPen asd", 2)));
        } */
    }
    @Override
    public int getCount() {
        return data.size();
    }
    @Override
    public long getItemId(int position) {
        return ID_CONSTANT + position;
    }
    @Override
    public RemoteViews getLoadingView() {
        return null;
    }
    @Override
    public RemoteViews getViewAt(int position) {

        POJOgetTask article = data.get(position);

        RemoteViews itemView = new RemoteViews(mContext.getPackageName(), R.layout.widget_task_item);

        itemView.setTextViewText(R.id.task_title, article.getTitle());
        itemView.setTextViewText(R.id.task_description, article.getDescription());
        itemView.setTextViewText(R.id.textView_creator, article.getCreator().getUsername());
        itemView.setTextViewText(R.id.textView_subject, article.getSubjectData().getName());
        itemView.setTextViewText(R.id.textView_deadline, article.getDueDate());

        Intent intent = new Intent();
        intent.putExtra(CollectionWidgetProvider.EXTRA_ITEM, article);
        itemView.setOnClickFillInIntent(R.layout.widget_task_item, intent);

        return itemView;
    }

    @Override
    public int getViewTypeCount() {
        return 1;
    }

    @Override
    public boolean hasStableIds() {
        return true;
    }

    @Override
    public void onDataSetChanged() {
        // Heavy lifting code can go here without blocking the UI.
        // You would update the data in your collection here as well.
        RemoteViews widgetView = new RemoteViews(mContext.getPackageName(), R.layout.hazizz_widget);
        widgetView.setTextViewText(R.id.widget_textView_content, "Betöltés...");

        CustomResponseHandler rh = new CustomResponseHandler() {
            @Override
            public void onResponse(HashMap<String, Object> response) {}
            @Override
            public void onPOJOResponse(Object response) {
                ArrayList<POJOgetTask> r = (ArrayList<POJOgetTask>) response;
                if (r == null || r.size() == 0) {
                    RemoteViews widgetView = new RemoteViews(mContext.getPackageName(), R.layout.hazizz_widget);
                    widgetView.setTextViewText(R.id.widget_textView_content, "Nincs feladat");
                } else {
                    data = D8.sortTasksByDate(r);
                    RemoteViews widgetView = new RemoteViews(mContext.getPackageName(), R.layout.hazizz_widget);
                    widgetView.setTextViewText(R.id.widget_textView_content, "ASADASDASD");
                }
                Log.e("hey", "pojo response");
            }
            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                Log.e("hey", "timeout maybe");
            }
            @Override
            public void onErrorResponse(POJOerror error) {
                Log.e("hey", "error response");
                RemoteViews widgetView = new RemoteViews(mContext.getPackageName(), R.layout.hazizz_widget);
                if(error.getErrorCode() == 17) {
                    widgetView.setTextViewText(R.id.widget_textView_content, "Nem vagy bejelentkezve");
                }else{
                    widgetView.setTextViewText(R.id.widget_textView_content, "else");
                }
            }
            @Override
            public void onEmptyResponse() { }
            @Override
            public void onSuccessfulResponse() { }
            @Override
            public void onNoConnection() { }
        };



        if(!SharedPrefs.TokenManager.getToken(mContext).equals("")) {
            Request request = new Request(mContext, "getTasksFromMeSync", null, rh, null);
            request.requestType.setupCall();
            request.requestType.makeCall();
        }else{
            data.clear();
          //  widgetView.setTextColor(R.id.w);
            widgetView = new RemoteViews(mContext.getPackageName(), R.layout.hazizz_widget);
            widgetView.setTextViewText(R.id.widget_textView_content, "Nem vagy bejelentkezve");
            widgetView.setViewVisibility(R.id.widget_textView_content, View.VISIBLE);
         //   widgetView.setViewVisibility(R.id.widget_frameLayout, View.INVISIBLE);
          //  widgetView.setEmptyView(R.id.widget_stack, R.id.o);
         //   AppWidgetManager manager = AppWidgetManager.getInstance(mContext);
         //   manager.updateAppWidget(this, widgetView);

        /*    final AppWidgetManager mgr = AppWidgetManager.getInstance(mContext);
            final ComponentName cn = new ComponentName(mContext, CollectionWidgetProvider.class);
           // mgr.updateAppWidget(mgr.getAppWidgetIds(cn), R.id.widget_stack);

            int[] widgetIds = mgr.getAppWidgetIds(cn);
            for (int widgetId : widgetIds) {

                RemoteViews remoteViews = new RemoteViews(mContext.getPackageName(), R.layout.hazizz_widget);

                widgetView.setTextViewText(R.id.widget_textView_content, "Nem vagy bejelentkezve");

                widgetView.setTextViewText(R.id.appwidget_text, "Nem vagy bejelentkezve");

                Log.e("hey", "happening");

                mgr.updateAppWidget(widgetId, remoteViews);
            } */

        }



        Log.e("hey", "onDataSetChanged called");
    }

    @Override
    public void onDestroy() {
        data.clear();
    }
}