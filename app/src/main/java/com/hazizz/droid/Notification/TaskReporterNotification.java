package com.hazizz.droid.Notification;

import android.app.AlarmManager;
import android.app.Notification;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.media.RingtoneManager;

import com.hazizz.droid.R;
import com.hazizz.droid.SharedPrefs;

import java.util.Calendar;
import java.util.TimeZone;

public class TaskReporterNotification {
    private static final String fileName = "ReportTaskSchedule";

    public static void setEnabled(Context context, boolean state){
        SharedPrefs.savePref(context, fileName, "enabled", state);
    }

    public static void setSchedule(Context context, int hour, int minute){
        if(SharedPrefs.getBoolean(context, fileName, "enabled")){
            SharedPrefs.save(context, fileName, "hour", hour);
            SharedPrefs.save(context, fileName, "minute", minute);
            SharedPrefs.savePref(context, fileName, "setOnce", true);
            SharedPrefs.savePref(context, fileName, "isOn", true);
        }
    }

    public static int getScheduleHour(Context context){
        return SharedPrefs.getInt(context, fileName, "hour");
    }
    public static int getScheduleMinute(Context context){
        return SharedPrefs.getInt(context, fileName, "minute");
    }

    public static void setNotification(Context context, int hour, int minute){
       // setEnabled(context, true);
        if(SharedPrefs.getBoolean(context, fileName, "enabled")) {
            setSchedule(context, hour, minute);
            scheduleNotification(context, getNotification(context));
        }
    }


    public static Notification getNotification(Context context) {
        Notification noti = null;
        if(SharedPrefs.getBoolean(context, fileName, "enabled")) {
            noti = new Notification.Builder(context)
                    .setStyle(new Notification.BigTextStyle().bigText("big text big text big text big text big text big text big text big text " +
                            "big text big text big text big text big text big text big text big text big text " +
                            "big text big text big text big text big text big text big text big text big text " +
                            "big text big text big text big text big text big text "))
                    .setContentTitle("Feladataid holnapra:")
                    .setContentText("3 befejezetlen feladat holnapra")
                    .setSmallIcon(R.mipmap.ic_launcher2)
                    .setDefaults(Notification.DEFAULT_LIGHTS | Notification.DEFAULT_SOUND)

                    .setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION))
                    .build();
        }
        return noti;
    }

    public static void scheduleNotification(Context context, Notification notification) {
        if(SharedPrefs.getBoolean(context, fileName, "enabled")) {
            int hour, minute;
            if (SharedPrefs.getBoolean(context, fileName, "setOnce")) {
                hour = getScheduleHour(context);
                minute = getScheduleMinute(context);
            } else {
                hour = 18;
                minute = 0;
            }
            Calendar updateTime = Calendar.getInstance();
            updateTime.setTimeZone(TimeZone.getTimeZone("GMT"));
            updateTime.set(Calendar.HOUR_OF_DAY, hour);
            updateTime.set(Calendar.MINUTE, minute);

            Intent notificationIntent = new Intent(context, NotificationReciever.class);
            notificationIntent.putExtra(NotificationReciever.NOTIFICATION_ID, 1);
            notificationIntent.putExtra(NotificationReciever.NOTIFICATION, notification);

            PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 0, notificationIntent, PendingIntent.FLAG_CANCEL_CURRENT);
            AlarmManager alarms = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
            alarms.setInexactRepeating(AlarmManager.RTC_WAKEUP,
                    updateTime.getTimeInMillis(),
                    AlarmManager.INTERVAL_DAY, pendingIntent);

            // alarmManager.setInexactRepeating(AlarmManager.RTC_WAKEUP, futureInMillis,
            //        AlarmManager.INTERVAL_DAY, pendingIntent);
        }
    }
}
