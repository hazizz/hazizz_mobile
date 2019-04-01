package com.hazizz.droid.widget.tasks;

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

import com.hazizz.droid.Activities.AuthActivity;
import com.hazizz.droid.Manager;
import com.hazizz.droid.R;

public class CollectionWidgetProvider extends AppWidgetProvider {

    public static final String WIDGET_REFRESHBUTTON = "com.hazizz.droid.widget.tasks.WIDGET_REFRESHBUTTON";
    public static final String WIDGET_OPENAPPBUTTON = "com.hazizz.droid.widget.tasks.WIDGET_OPENAPPBUTTON";

    public static final String EXTRA_STRING = "extraString";
    public static final String ACTION_TOAST = "actionToast";
    public static final String EXTRA_ITEM_POSITION = "extraItemPosition";


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

    /*
    static void updateAppWidget(Context context, AppWidgetManager appWidgetManager,
                                int appWidgetId) {
        views = new RemoteViews(context.getPackageName(), R.layout.test_widget);
        views.setOnClickPendingIntent(R.id.wid_btn_tst, setButton(context));

        appWidgetManager.updateAppWidget(appWidgetId, views);
    }
    */




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

            setRefreshButton(context, widgetView);
            setOpenAppButton(context, widgetView);


       /*     intent = new Intent(context, AuthActivity.class);
            pendingIntent = PendingIntent.getActivity(context, 0, intent, 0);
            widgetView.setOnClickPendingIntent(R.id.button_openapp, pendingIntent); */

           // widgetView.setOnClickPendingIntent(R.id.button_refresh, getPendingSelfIntent(context, MyOnClick));

            Intent detailIntent = new Intent(context, CollectionWidgetProvider.class);
            detailIntent.setAction(ACTION_VIEW_DETAILS);
            PendingIntent pIntent = PendingIntent.getBroadcast(context, 0, detailIntent, PendingIntent.FLAG_UPDATE_CURRENT);
            widgetView.setPendingIntentTemplate(R.id.widget_stack, pIntent);


            RemoteViews widgetViewList = new RemoteViews(context.getPackageName(), R.layout.widget_task_item);

            Intent clickIntent = new Intent(context, CollectionWidgetProvider.class);
            clickIntent.setAction(ACTION_TOAST);
            PendingIntent clickPendingIntent = PendingIntent.getBroadcast(context,
                    0, clickIntent, PendingIntent.FLAG_UPDATE_CURRENT);
            widgetViewList.setPendingIntentTemplate(R.id.widget_stack, clickPendingIntent);


            final Intent onItemClick = new Intent(context, CollectionWidgetProvider.class);
            onItemClick.setAction(ACTION_TOAST);
            onItemClick.setData(Uri.parse(onItemClick
                    .toUri(Intent.URI_INTENT_SCHEME)));
            final PendingIntent onClickPendingIntent = PendingIntent
                    .getBroadcast(context, 0, onItemClick,
                            PendingIntent.FLAG_UPDATE_CURRENT);
            widgetViewList.setPendingIntentTemplate(R.id.widget_stack,
                    onClickPendingIntent);

            Log.e("hey", "On update");


            appWidgetManager.updateAppWidget(widgetId, widgetViewList);
            appWidgetManager.updateAppWidget(widgetId, widgetView);
            Log.e("hey", "looping");
        }
        Log.e("hey", "updateing");

        super.onUpdate(context, appWidgetManager, appWidgetIds);
    }

    private void setRefreshButton(Context context, RemoteViews remoteViews){
        remoteViews.setInt(R.id.button_refresh, "setImageResource", R.drawable.ic_refresh_grey);
        Intent buttonIntent = new Intent(context, CollectionWidgetProvider.class);
        buttonIntent.setAction(WIDGET_REFRESHBUTTON);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 0, buttonIntent, PendingIntent.FLAG_UPDATE_CURRENT);
        remoteViews.setOnClickPendingIntent(R.id.button_refresh, pendingIntent);
    }

    private void setOpenAppButton(Context context, RemoteViews remoteViews){
        remoteViews.setInt(R.id.button_openapp, "setImageResource", R.drawable.ic_add_black_24dp);
        Intent buttonIntent = new Intent(context, CollectionWidgetProvider.class);
        buttonIntent.setAction(WIDGET_OPENAPPBUTTON);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 0, buttonIntent, PendingIntent.FLAG_UPDATE_CURRENT);
        remoteViews.setOnClickPendingIntent(R.id.button_openapp, pendingIntent);
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
        Log.e("hey", "RECIEVED INTENT");
        String intentAction = intent.getAction();

        if (WIDGET_REFRESHBUTTON.equals(intentAction)) {



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

            setRefreshButton(context, widgetView);
            setOpenAppButton(context, widgetView);

            mgr.updateAppWidget(mgr.getAppWidgetIds(cn),widgetView);
            Log.e("hey", "CLICK REFRESH BUTTON");
        }

        else if (WIDGET_OPENAPPBUTTON.equals(intentAction)) {

            RemoteViews widgetView = new RemoteViews(context.getPackageName(), R.layout.hazizz_widget);
            setRefreshButton(context, widgetView);
            setOpenAppButton(context, widgetView);

            Manager.WidgetManager.setDest(Manager.WidgetManager.TOATCHOOSER);
            Intent i = new Intent(context, AuthActivity.class);
            i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(i);
            Log.e("hey", "CLICK WIDGET_OPENAPPBUTTON");
        }

        if (ACTION_TOAST.equals(intentAction)) {
         //   int clickedPosition = intent.getIntExtra(EXTRA_ITEM_POSITION, 0);
            int clickedPosition = intent.getIntExtra(EXTRA_STRING, 0);
            Toast.makeText(context, "Clicked position: " + clickedPosition, Toast.LENGTH_SHORT).show();
            Log.e("hey", "click wdiget");
        }

        if  (intentAction.equals(ACTION_TOAST)) {
            String item = intent.getExtras().getString(EXTRA_STRING);
            Toast.makeText(context, item, Toast.LENGTH_LONG).show();
        }

        /*
        AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(context);
        ComponentName thisAppWidget = new ComponentName(context.getPackageName(), CollectionWidgetProvider.class.getName());
        int[] appWidgetIds = appWidgetManager.getAppWidgetIds(thisAppWidget);

        onUpdate(context, appWidgetManager, appWidgetIds);
        */

        super.onReceive(context, intent);
    }
}