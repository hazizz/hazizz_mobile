package com.indeed.hazizz;

import android.appwidget.AppWidgetManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;
import android.widget.RemoteViews;
import android.widget.RemoteViewsService;

import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgetTask;
import com.indeed.hazizz.Listviews.TaskList.TaskItem;

import java.util.HashMap;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;

public class WidgetService extends RemoteViewsService {

  //  public List<TaskItem> data = null;

    @Override
    public RemoteViewsFactory onGetViewFactory(Intent intent) {
        return new WidgetItemFactory(getApplicationContext(), intent);
    }


    public class WidgetItemFactory implements RemoteViewsFactory{

        private Context context;
        private Intent intent;
        private int appWidgetId;
        private List<POJOgetTask> data;

        WidgetItemFactory(Context context, Intent intent){
            this.context = context;
            this.intent = intent;
            this.appWidgetId = intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, AppWidgetManager.INVALID_APPWIDGET_ID);
         //   data = intent.getParcelableArrayListExtra("data");
        }

        @Override
        public void onCreate() {
            // connect to data source
            data = intent.getParcelableArrayListExtra("data");
        }

        @Override
        public void onDataSetChanged() {
            CustomResponseHandler rh = new CustomResponseHandler() {
                @Override
                public void onResponse(HashMap<String, Object> response) {

                }

                @Override
                public void onPOJOResponse(Object response) {
                    data = (List<POJOgetTask>)response;
                }

                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {

                }

                @Override
                public void onErrorResponse(POJOerror error) {

                }

                @Override
                public void onEmptyResponse() {

                }

                @Override
                public void onSuccessfulResponse() {

                }

                @Override
                public void onNoConnection() {

                }
            };

            MiddleMan.newRequest(null, "getTasksFromMe", null, rh, null);
        }

        @Override
        public void onDestroy() {
            // close data source
        }

        @Override
        public int getCount() {
            return data.size();
        }

        @Override
        public RemoteViews getViewAt(int i) {
            RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.task_item);
            views.setTextViewText(R.id.task_title, data.get(i).getTitle());
            views.setTextViewText(R.id.task_description, data.get(i).getDescription());
            views.setTextViewText(R.id.textView_creator, data.get(i).getCreator().getUsername());
            views.setTextViewText(R.id.textView_subject, data.get(i).getSubjectData().getName());
            views.setTextViewText(R.id.textView_deadline, data.get(i).getDueDate());

            Log.e("hey", "getViewAt happened");

            return views;
        }

        @Override
        public RemoteViews getLoadingView() {
            return null;
        }

        @Override
        public int getViewTypeCount() {
            return 1;
        }

        @Override
        public long getItemId(int i) {
            return i;
        }

        @Override
        public boolean hasStableIds() {
            return true;
        }

    }

}
