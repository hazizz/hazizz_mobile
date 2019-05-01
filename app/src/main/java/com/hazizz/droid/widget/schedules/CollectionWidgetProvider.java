package com.hazizz.droid.widget.schedules;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.RemoteViews;
import android.widget.Toast;

import com.hazizz.droid.activities.AuthActivity;
import com.hazizz.droid.R;

public class CollectionWidgetProvider extends AppWidgetProvider {

    public static final String WIDGET_RIGHTBUTTON = "com.hazizz.droid.schedules.WIDGET_RIGHTBUTTON";
    public static final String WIDGET_LEFTBUTTON = "com.hazizz.droid.schedules.WIDGET_LEFTBUTTON";

    public static final String EXTRA_STRING = "extraString2";
    public static final String ACTION_TOAST = "actionToast2";
    public static final String EXTRA_ITEM_POSITION = "extraItemPosition2";


    public static final String ACTION_VIEW_DETAILS =
            "com.company.android.ACTION_VIEW_DETAILS2";
    public static final String EXTRA_ITEM =
            "com.company.android.CollectionWidgetProvider.EXTRA_ITEM2";

    @Override
    public void onAppWidgetOptionsChanged(Context context, AppWidgetManager appWidgetManager, int appWidgetId, Bundle newOptions) {

        RemoteViews widgetView = new RemoteViews(context.getPackageName(), R.layout.widget_thera_schedules);

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

            RemoteViews widgetView = new RemoteViews(context.getPackageName(), R.layout.widget_thera_schedules);

            appWidgetManager.notifyAppWidgetViewDataChanged(widgetId, widgetView.getLayoutId());

            widgetView.setRemoteAdapter(R.id.widget_list, intent);
            widgetView.setEmptyView(R.id.widget_list, R.id.widget_info);

            widgetView.setInt(R.id.button_left, "setImageResource", R.drawable.ic_arrow_left_black);
            widgetView.setInt(R.id.button_right, "setImageResource", R.drawable.ic_arrow_right_black);

            Intent buttonIntent = new Intent(WIDGET_LEFTBUTTON);
            PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 0, buttonIntent, PendingIntent.FLAG_UPDATE_CURRENT);
            widgetView.setOnClickPendingIntent(R.id.button_left, pendingIntent);

            buttonIntent = new Intent(WIDGET_RIGHTBUTTON);
            pendingIntent = PendingIntent.getBroadcast(context, 0, buttonIntent, PendingIntent.FLAG_UPDATE_CURRENT);
            widgetView.setOnClickPendingIntent(R.id.button_right, pendingIntent);


       /*     intent = new Intent(context, AuthActivity.class);
            pendingIntent = PendingIntent.getActivity(context, 0, intent, 0);
            widgetView.setOnClickPendingIntent(R.id.button_openapp, pendingIntent); */

            Intent detailIntent = new Intent(ACTION_VIEW_DETAILS);
            PendingIntent pIntent = PendingIntent.getBroadcast(context, 0, detailIntent, PendingIntent.FLAG_UPDATE_CURRENT);
            widgetView.setPendingIntentTemplate(R.id.widget_list, pIntent);


            RemoteViews widgetViewList = new RemoteViews(context.getPackageName(), R.layout.item_widget_thera_schedule);

            Intent clickIntent = new Intent(context, CollectionWidgetProvider.class);
            clickIntent.setAction(ACTION_TOAST);
            PendingIntent clickPendingIntent = PendingIntent.getBroadcast(context,
                    0, clickIntent, PendingIntent.FLAG_UPDATE_CURRENT);
            widgetViewList.setPendingIntentTemplate(R.id.widget_list, clickPendingIntent);


            final Intent onItemClick = new Intent(context, CollectionWidgetProvider.class);
            onItemClick.setAction(ACTION_TOAST);
            onItemClick.setData(Uri.parse(onItemClick
                    .toUri(Intent.URI_INTENT_SCHEME)));
            final PendingIntent onClickPendingIntent = PendingIntent
                    .getBroadcast(context, 0, onItemClick,
                            PendingIntent.FLAG_UPDATE_CURRENT);
            widgetViewList.setPendingIntentTemplate(R.id.widget_list,
                    onClickPendingIntent);

            Log.e("hey", "On update");


            appWidgetManager.updateAppWidget(widgetId, widgetViewList);
            appWidgetManager.updateAppWidget(widgetId, widgetView);

            appWidgetManager.notifyAppWidgetViewDataChanged(widgetId, widgetView.getLayoutId());



            Log.e("hey", "looping");
        }
        Log.e("hey", "updateing");

        super.onUpdate(context, appWidgetManager, appWidgetIds);
    }

    @Override
    public void onReceive(Context context, Intent intent) {
      /*  if(intent.getAction().equals(ACTION_VIEW_DETAILS)) {
             PojoTask article = ( PojoTask)intent.getSerializableExtra(EXTRA_ITEM);
            if(article != null) {
                // Handle the click here.
                // Maybe start a details activity?
                // Maybe consider using an Activity PendingIntent instead of a Broadcast?
            }
        }*/
        Log.e("hey", "RECIEVED");

        if (WIDGET_RIGHTBUTTON.equals(intent.getAction())) {
           // String str = intent.getAction();
            final AppWidgetManager mgr = AppWidgetManager.getInstance(context);
            final ComponentName cn = new ComponentName(context, CollectionWidgetProvider.class);
            mgr.notifyAppWidgetViewDataChanged(mgr.getAppWidgetIds(cn), R.id.widget_list);

            RemoteViews widgetView = new RemoteViews(context.getPackageName(), R.layout.widget_thera_schedules);

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

        else if (WIDGET_LEFTBUTTON.equals(intent.getAction())) {
            Intent i = new Intent(context, AuthActivity.class);
            i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(i);
            Log.e("hey", "CLICK WIDGET_OPENAPPBUTTON");
        }

        if (ACTION_TOAST.equals(intent.getAction())) {
         //   int clickedPosition = intent.getIntExtra(EXTRA_ITEM_POSITION, 0);
            int clickedPosition = intent.getIntExtra(EXTRA_STRING, 0);
            Toast.makeText(context, "Clicked position: " + clickedPosition, Toast.LENGTH_SHORT).show();
            Log.e("hey", "click wdiget");
        }

        if  (intent.getAction().equals(ACTION_TOAST)) {
            String item = intent.getExtras().getString(EXTRA_STRING);
            Toast.makeText(context, item, Toast.LENGTH_LONG).show();
        }

        super.onReceive(context, intent);
    }
}