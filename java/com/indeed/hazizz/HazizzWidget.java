package com.indeed.hazizz;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.SystemClock;
import android.util.Log;
import android.widget.RemoteViews;

import com.indeed.hazizz.Communication.MiddleMan;
import com.indeed.hazizz.Communication.POJO.Response.CustomResponseHandler;
import com.indeed.hazizz.Communication.POJO.Response.POJOerror;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgetTask;
import com.indeed.hazizz.Listviews.TaskList.TaskItem;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * Implementation of App Widget functionality.
 * App Widget Configuration implemented in {@link HazizzWidgetConfigureActivity HazizzWidgetConfigureActivity}
 */
public class HazizzWidget extends AppWidgetProvider {

  /*  HazizzWidget(){
        Thread SenderThread = new Thread(new RequestSenderRunnable());
        SenderThread.start();
    } */


    private static int count = 0;
    private PendingIntent service;
    private static final String ACTION_SIMPLEAPPWIDGET = "ACTION_BROADCASTWIDGETSAMPLE";

    static void updateAppWidget(Context context, AppWidgetManager appWidgetManager,
                                int appWidgetId) {

      /*  CharSequence widgetText = HazizzWidgetConfigureActivity.loadTitlePref(context, appWidgetId);
        // Construct the RemoteViews object
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.hazizz_widget);
        views.setTextViewText(R.id.appwidget_text, widgetText);

        // Instruct the widget manager to update the widget
        appWidgetManager.updateAppWidget(appWidgetId, views); */

     /*   // Construct the RemoteViews object
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.hazizz_widget);
        // Construct an Intent object includes web adresss.
        Intent intent = new Intent(context, HazizzWidget.class);//  Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse("http://erenutku.com"));
        intent.setAction(ACTION_SIMPLEAPPWIDGET);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT);
        // In widget we are not allowing to use intents as usually. We have to use PendingIntent instead of 'startActivity'
      //  PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, intent, 0);
        // Here the basic operations the remote view can do.
        views.setOnClickPendingIntent(R.id.appwidget_text, pendingIntent);
        // Instruct the widget manager to update the widget
        appWidgetManager.updateAppWidget(appWidgetId, views); */
    }


    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {



        final AlarmManager manager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
        final Intent updateServiceIntent = new Intent(context, UpdateService.class);



        if (service == null) {
            service = PendingIntent.getService(context, 0, updateServiceIntent, PendingIntent.FLAG_CANCEL_CURRENT);
        }
        manager.setRepeating(AlarmManager.ELAPSED_REALTIME, SystemClock.elapsedRealtime(), 60000, service);

        Log.e("hey", "update called");


       /* for (int appWidgetId : appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId);

            final AlarmManager manager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
            final Intent i = new Intent(context, UpdateService.class);

            if (service == null) {
                service = PendingIntent.getService(context, 0, i, PendingIntent.FLAG_CANCEL_CURRENT);
            }
            manager.setRepeating(AlarmManager.ELAPSED_REALTIME, SystemClock.elapsedRealtime(), 60000, service);
        } */

        // There may be multiple widgets active, so update all of them
      /*  for (int appWidgetId : appWidgetIds) {
            CustomResponseHandler rh = new CustomResponseHandler() {
                @Override
                public void onResponse(HashMap<String, Object> response) {

                }

                @Override
                public void onPOJOResponse(Object response) {
                    ArrayList<POJOgetTask> castedList = (ArrayList<POJOgetTask>)response;

                    updateAppWidget(context, appWidgetManager, appWidgetId);

                    Intent serviceIntent = new Intent(context, WidgetService.class);

                    serviceIntent.putParcelableArrayListExtra("data", castedList);

                    serviceIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId);
                    serviceIntent.setData(Uri.parse(serviceIntent.toUri(Intent.URI_INTENT_SCHEME)));

                    RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.hazizz_widget);
                    views.setRemoteAdapter(R.id.widget_stack, serviceIntent);
                    views.setEmptyView(R.id.widget_stack, R.id.widget_epmty);

                  //  Bundle appWidgetOptions = appWidgetManager.getAppWidgetOptions(appWidgetId);
                    appWidgetManager.updateAppWidget(appWidgetId, views);
                    Log.e("hey", "got POJOresponse");

                }

                @Override
                public void onFailure() {

                }

                @Override
                public void onErrorResponse(POJOerror error) {
                    Log.e("hey", "got error: " + error.getErrorCode());

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

            MiddleMan.newRequest(context,"getTasksFromMe", null, rh, null);
            Log.e("hey", "sent request: getTasksFromMe");
        }
        */
    }

    private void resiteWidget(Bundle appWidgetOptions, RemoteViews views){
        int minWidth = appWidgetOptions.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH);
        int maxWidth = appWidgetOptions.getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_WIDTH);
        int minHeight = appWidgetOptions.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT);
        int maxHeight = appWidgetOptions.getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_HEIGHT);



    }

    @Override
    public void onDeleted(Context context, int[] appWidgetIds) {
        // When the user deletes the widget, delete the preference associated with it.
        for (int appWidgetId : appWidgetIds) {
            HazizzWidgetConfigureActivity.deleteTitlePref(context, appWidgetId);
        }
    }

    @Override
    public void onEnabled(Context context) {
        // Enter relevant functionality for when the first widget is created
    }

    @Override
    public void onDisabled(Context context) {
        // Enter relevant functionality for when the last widget is disabled
    }

    @Override
    public void onReceive(Context context, Intent intent) {

        super.onReceive(context, intent);
    /*    if (ACTION_SIMPLEAPPWIDGET.equals(intent.getAction())) {
            mCounter++;
            // Construct the RemoteViews object
            RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.hazizz_widget);
            views.setTextViewText(R.id.appwidget_text, Integer.toString(mCounter));
            // This time we dont have widgetId. Reaching our widget with that way.
            ComponentName appWidget = new ComponentName(context, HazizzWidget.class);
            AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(context);
            // Instruct the widget manager to update the widget
            appWidgetManager.updateAppWidget(appWidget, views);
        } */

      /*  super.onReceive(context, intent);

        AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(context);
        RemoteViews remoteViews = new RemoteViews(context.getPackageName(), R.layout.hazizz_widget);
      //  WidgetService widgetService = new WidgetService(context, WidgetService.class);


        switch(intent.getAction()) {
            case Intent.ACTION_SCREEN_OFF:
                Log.e("hey", "screen is off");
                break;

            case Intent.ACTION_SCREEN_ON:
                Log.e("hey", "screen is on");
                break;
        } */


       // appWidgetManager.updateAppWidget(appWidgetId, remoteViews);

    }
}

