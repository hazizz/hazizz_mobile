package com.hazizz.droid.notification;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class NotificationReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {

        if(TaskReporterNotification.isEnabled(context)){
            TaskReporterNotification.createNotification(context);
        }


        Log.e("hey", "RECEIVeD alarm manager");
    }
}