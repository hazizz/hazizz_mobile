package com.indeed.hazizz;

import android.app.Service;
import android.appwidget.AppWidgetManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.IBinder;
import android.support.annotation.Nullable;
import android.util.Log;
import android.widget.RemoteViews;

import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgetTask;

import java.util.HashMap;
import java.util.List;
import java.util.Random;

import okhttp3.ResponseBody;
import retrofit2.Call;

/**
 * Created by yutku on 29/11/16.
 */

public class UpdateService extends Service {



    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        // generates random number
        Context context = this;
        Random random = new Random();
        int randomInt = random.nextInt(100);
        String lastUpdate = "R: "+randomInt;
        // Reaches the view on widget and displays the number
        RemoteViews view = new RemoteViews(getPackageName(), R.layout.hazizz_widget);
        view.setTextViewText(R.id.appwidget_text, lastUpdate);
        ComponentName theWidget = new ComponentName(this, HazizzWidget.class);
        AppWidgetManager manager = AppWidgetManager.getInstance(this);
      //  manager.updateAppWidget(theWidget, view);

        CustomResponseHandler rh = new CustomResponseHandler() {
            @Override
            public void onResponse(HashMap<String, Object> response) {

            }

            @Override
            public void onPOJOResponse(Object response) {
                List<POJOgetTask> castedList = (List<POJOgetTask>)response;
                view.setTextViewText(R.id.appwidget_text, castedList.get(0).getTitle());

                Log.e("hey", "recieved POJO response");


                Intent widgetServiceIntent = new Intent(context, WidgetService.class);
                widgetServiceIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, 0);
                widgetServiceIntent.setData(Uri.parse(widgetServiceIntent.toUri(Intent.URI_INTENT_SCHEME)));

                RemoteViews views = new RemoteViews(getPackageName(), R.layout.hazizz_widget);
                views.setRemoteAdapter(R.id.widget_stack, widgetServiceIntent);
                views.setEmptyView(R.id.widget_stack, R.id.widget_info);

                ComponentName name = new ComponentName(context, HazizzWidget.class);
                int [] ids = AppWidgetManager.getInstance(context).getAppWidgetIds(name);

                manager.notifyAppWidgetViewDataChanged(ids, views.getLayoutId());
                manager.updateAppWidget(theWidget, view);

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

    //    MiddleMan.newRequest(this,"getTasksFromMe", null, rh, null);

    //    manager.notifyAppWidgetViewDataChanged(theWidget, view.getLayoutId());

        return super.onStartCommand(intent, flags, startId);
    }
}