package com.hazizz.droid.notification;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.hazizz.droid.other.SharedPrefs;

public class NotificationReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {

        if(TaskReporterNotification.isEnabled(context)){
            TaskReporterNotification.createNotification(context);
        }

        int count = SharedPrefs.getInt(context, "gotAlarm", "asd", 0);
        count++;

        SharedPrefs.save(context, "gotAlarm", "asd", count);

        Log.e("hey", "RECEIVeD alarm manager: " + count);
    }
}