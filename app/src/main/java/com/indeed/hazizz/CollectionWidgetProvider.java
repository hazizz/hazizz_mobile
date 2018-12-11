package com.indeed.hazizz;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.RemoteViews;

import com.indeed.hazizz.Activities.AuthActivity;

public class CollectionWidgetProvider extends AppWidgetProvider {

    public static final String WIDGET_REFRESHBUTTON = "com.indeed.hazizz.WIDGET_REFRESHBUTTON";
    public static final String WIDGET_OPENAPPBUTTON = "com.indeed.hazizz.WIDGET_OPENAPPBUTTON";

    public static final String ACTION_VIEW_DETAILS =
            "com.company.android.ACTION_VIEW_DETAILS";
    public static final String EXTRA_ITEM =
            "com.company.android.CollectionWidgetProvider.EXTRA_ITEM";

    @Override
    public void onAppWidgetOptionsChanged(Context context, AppWidgetManager appWidgetManager, int appWidgetId, Bundle newOptions) {

        RemoteViews widgetView = new RemoteViews(context.getPackageName(), R.layout.hazizz_widget);

        // See the dimensions and
        Bundle options = appWidgetManager.getAppWidgetOptions(appWidgetId);

        // Get min width and height.
        int width = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH);
        int height = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT);

        if(width >= 320){

          //  widgetView.setInt(R.id.task_description, "setWidth", 200);
          //  widgetView.setViewPadding(R.id.task_description, 0, 0, 200, 150);
            Log.e("hey", "cell: 5");


        }else{
           // widgetView.setInt(R.id.task_description, "setWidth", 100);
          //  widgetView.setViewPadding(R.id.task_description, 0, 0, 150, 100);
            Log.e("hey", "cell less than 5");
        }

        Log.e("hey", "changed layout. width: " + width);

        // Obtain appropriate widget and update it.

      //  AppWidgetManager.getInstance(context).getAppWidgetInfo(appWidgetId).

       // options.getInt(AppWidgetManager.)


        appWidgetManager.updateAppWidget(appWidgetId, widgetView);
        super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions);
    }

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager,
                         int[] appWidgetIds) {

        for(int i = 0; i < appWidgetIds.length; i++) {


            int widgetId = appWidgetIds[i];

            Intent intent = new Intent(context, CollectionWidgetService.class);
            intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId);

            RemoteViews widgetView = new RemoteViews(context.getPackageName(), R.layout.hazizz_widget);

            appWidgetManager.notifyAppWidgetViewDataChanged(widgetId, widgetView.getLayoutId());

            widgetView.setRemoteAdapter(R.id.widget_stack, intent);
            widgetView.setEmptyView(R.id.widget_stack, R.id.widget_info);

            Intent detailIntent = new Intent(ACTION_VIEW_DETAILS);
            PendingIntent pIntent = PendingIntent.getBroadcast(context, 0, detailIntent, PendingIntent.FLAG_UPDATE_CURRENT);
            widgetView.setPendingIntentTemplate(R.id.widget_stack, pIntent);

            Intent buttonIntent = new Intent(WIDGET_REFRESHBUTTON);
            PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 0, buttonIntent, PendingIntent.FLAG_UPDATE_CURRENT);
            widgetView.setOnClickPendingIntent(R.id.button_refresh, pendingIntent);

            intent = new Intent(context, AuthActivity.class);
            pendingIntent = PendingIntent.getActivity(context, 0, intent, 0);
            widgetView.setOnClickPendingIntent(R.id.button_openapp, pendingIntent);

            widgetView.setInt(R.id.button_refresh, "setImageResource", R.drawable.ic_refresh_grey);
            widgetView.setInt(R.id.button_openapp, "setImageResource", R.drawable.ic_open_app_grey);

            appWidgetManager.updateAppWidget(widgetId, widgetView);
            Log.e("hey", "looping");
        }
        Log.e("hey", "updateing");

        super.onUpdate(context, appWidgetManager, appWidgetIds);
    }

    @Override
    public void onReceive(Context context, Intent intent) {

      /*  if(intent.getAction().equals(ACTION_VIEW_DETAILS)) {
            POJOgetTask article = (POJOgetTask)intent.getSerializableExtra(EXTRA_ITEM);
            if(article != null) {
                // Handle the click here.
                // Maybe start a details activity?
                // Maybe consider using an Activity PendingIntent instead of a Broadcast?
            }
        }*/
        Log.e("hey", "RECIEVED");

        if (WIDGET_REFRESHBUTTON.equals(intent.getAction())) {
           // String str = intent.getAction();
            final AppWidgetManager mgr = AppWidgetManager.getInstance(context);
            final ComponentName cn = new ComponentName(context, CollectionWidgetProvider.class);
            mgr.notifyAppWidgetViewDataChanged(mgr.getAppWidgetIds(cn), R.id.widget_stack);

            RemoteViews widgetView = new RemoteViews(context.getPackageName(), R.layout.hazizz_widget);

            String contentInfo = CollectionWidgetViewFactory.getContentInfo();
            if(contentInfo.equals("")){
                widgetView.setViewVisibility(R.id.widget_textView_content, View.INVISIBLE);
            }else {
                widgetView.setViewVisibility(R.id.widget_textView_content, View.VISIBLE);

                widgetView.setTextViewText(R.id.widget_textView_content, contentInfo);
            }
            mgr.updateAppWidget(mgr.getAppWidgetIds(cn),widgetView);
            Log.e("hey", "CLICK REFRESH BUTTON");
        }
        super.onReceive(context, intent);
    }
}