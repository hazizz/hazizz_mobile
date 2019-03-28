package com.hazizz.droid.Notification;

import android.app.Notification;
import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class NotificationReciever extends BroadcastReceiver {
    public static String NOTIFICATION_ID = "notification-id";
    public static String NOTIFICATION = "notification";

    public void onReceive(Context context, Intent intent) {

        NotificationManager notificationManager = (NotificationManager)context.getSystemService(Context.NOTIFICATION_SERVICE);

        if(notificationManager == null){
            Log.e("hey", "99 notificationManager is null");
        }
        Notification notification = intent.getParcelableExtra(NOTIFICATION);
        if(notification == null){
            Log.e("hey", "99 notification is null");
        }


       /* if(notification.sound == null){
            Log.e("hey", "99 notification.sound is null");
        } */

        int id = intent.getIntExtra(NOTIFICATION_ID, 0);

        notificationManager.notify(id, notification);



    }
}