package com.hazizz.droid.notification;

import android.app.AlarmManager;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Typeface;
import android.media.RingtoneManager;
import android.os.Bundle;
import android.provider.Settings;
import android.support.v4.app.NotificationCompat;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.style.StyleSpan;
import android.util.Log;

import com.hazizz.droid.activities.AuthActivity;
import com.hazizz.droid.activities.MainActivity;

import com.hazizz.droid.communication.requests.GetTasksFromMe;
import com.hazizz.droid.communication.responsePojos.CustomResponseHandler;
import com.hazizz.droid.communication.responsePojos.taskPojos.PojoTask;
import com.hazizz.droid.other.D8;
import com.hazizz.droid.listeners.GenericListener;
import com.hazizz.droid.other.Network;
import com.hazizz.droid.R;
import com.hazizz.droid.other.SharedPrefs;
import com.hazizz.droid.receiver.BroadcastReceiverHandler;
import com.hazizz.droid.receiver.NetworkChangeReceiver;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.concurrent.TimeUnit;

public class TaskReporterNotification {
    private static final String fileName = "ReportTaskSchedule";
    private static final String enabled_key = "enabled";


    public static void enable(Context context){
        SharedPrefs.savePref(context, fileName, enabled_key, true);
    }

    public static void disable(Context context){

        SharedPrefs.savePref(context, fileName, enabled_key, false);
    }

    public static boolean isEnabled(Context context){
        return SharedPrefs.getBoolean(context, fileName, enabled_key);
    }

    public static void setSchedule(Context context, int hour, int minute){
        if(isEnabled(context)){
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

    public static void remindScheduleForNotification(Context context) {
        setScheduleForNotification(context, getScheduleHour(context), getScheduleMinute(context));

    }

    public static void setScheduleForNotification(Context context, int hour, int minute) {
        Log.e("hey", "alarm manager set");
        setSchedule(context, hour, minute);
        Intent _intent = new Intent(context, NotificationReceiver.class);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 0, _intent, PendingIntent.FLAG_UPDATE_CURRENT);
        AlarmManager alarmManager = (AlarmManager)context.getSystemService(Context.ALARM_SERVICE);

        alarmManager.cancel(pendingIntent);
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(System.currentTimeMillis());
        calendar.set(Calendar.HOUR_OF_DAY, hour);
        calendar.set(Calendar.MINUTE, minute);
        calendar.set(Calendar.SECOND, 0);

        if (calendar.before(Calendar.getInstance())) {
            calendar.add(Calendar.DAY_OF_MONTH, 1);
        }

        //alarmManager.setRepeating(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), AlarmManager.INTERVAL_DAY, pendingIntent);
        alarmManager.setRepeating(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), TimeUnit.MILLISECONDS.convert(1, TimeUnit.DAYS), pendingIntent);
      //  alarmManager.setRepeating(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), 1000 * 60 * 3, pendingIntent); //TimeUnit.MILLISECONDS.convert(5, TimeUnit.SECONDS)

    }

    private static void ifConnectionCreateNotification(Context context){
        BroadcastReceiverHandler networkChangeReceiver = new BroadcastReceiverHandler(new NetworkChangeReceiver());
        networkChangeReceiver.setOnReceive(new GenericListener() {
            @Override
            public void execute() {
                if(Network.isConnectedToWifi(context) || Network.isConnectedToMobileNet(context)) {
                    GetTasksFromMe getTasksRequest = new GetTasksFromMe(context, new CustomResponseHandler() {
                        @Override
                        public void onPOJOResponse(Object response) {
                            Log.e("hey", "got response for notif2");
                            List<PojoTask> tasks = (List< PojoTask>) response;
                            List< PojoTask> tasksToReport = new ArrayList<>();

                            for ( PojoTask task : tasks) {
                                if (D8.textToDate(task.getDueDate()).daysLeft() == 1) {
                                    tasksToReport.add(task);
                                }
                            }
                            if (!tasksToReport.isEmpty()) {
                                showNotification(context, tasksToReport);
                            }
                            networkChangeReceiver.unregister(context);
                        }
                    });
                    getTasksRequest.setupCall();
                    getTasksRequest.makeCall();
                }
            }
        });
        networkChangeReceiver.register(context);
    }

    public static void createNotification(Context context){
        if(Network.isConnectedToWifi(context) || Network.isConnectedToMobileNet(context)) {
            GetTasksFromMe getTasksRequest = new GetTasksFromMe(context, new CustomResponseHandler() {
                @Override
                public void onPOJOResponse(Object response) {
                    Log.e("hey", "got response for notif");
                    List< PojoTask> tasks = (List< PojoTask>) response;
                    List< PojoTask> tasksToReport = new ArrayList<>();

                    for ( PojoTask task : tasks) {
                        if (D8.textToDate(task.getDueDate()).daysLeft() == 1) {
                            tasksToReport.add(task);
                        }
                    }
                    if (!tasksToReport.isEmpty()) {
                        showNotification(context, tasksToReport);
                    }
                }
                @Override
                public void onNoConnection() {
                    ifConnectionCreateNotification(context);
                }
            });
            getTasksRequest.setupCall();
            getTasksRequest.makeCall();
        }else{
            ifConnectionCreateNotification(context);
        }
    }


    public static void showNotification(Context context, List< PojoTask> tasks) {
        String CHANNEL_ID = "your_name";// The id of the channel.
        CharSequence name = context.getResources().getString(R.string.app_name);// The user-visible name of the channel.
        NotificationCompat.Builder mBuilder;
        Intent notificationIntent = new Intent(context, MainActivity.class);

        notificationIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_MULTIPLE_TASK);
        NotificationManager mNotificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

        NotificationCompat.InboxStyle inboxStyle = new NotificationCompat.InboxStyle();


        Bundle bundle = new Bundle();



        for( PojoTask task : tasks) {
            Spannable sb;
            if(task.getSubject()!= null){
                String subject = task.getSubject().getName();
                String title = task.getTitle();
                String description = task.getDescription();

                String divider = " : ";

                int i_start_subject = 0;
                int i_end_subject = i_start_subject + subject.length();
                int i_start_title = subject.length() + divider.length();
                int i_end_title = i_start_title + title.length() + 1;

                sb = new SpannableString(subject + divider + title + divider + description);

                sb.setSpan(new StyleSpan(Typeface.BOLD), i_start_subject, i_end_subject, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
                sb.setSpan(new StyleSpan(Typeface.BOLD), i_start_title, i_end_title, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
            }else{
                String title = task.getTitle();
                String description = task.getDescription();

                String divider = " : ";

                int i_start_title = 0;
                int i_end_title = title.length();


                sb = new SpannableString(title + divider + description);

                sb.setSpan(new StyleSpan(Typeface.BOLD), i_start_title, i_end_title, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);

            }
            inboxStyle.addLine(sb);
        }

        if (android.os.Build.VERSION.SDK_INT >= 26) {
            NotificationChannel mChannel = new NotificationChannel(CHANNEL_ID, name, NotificationManager.IMPORTANCE_HIGH);
            mNotificationManager.createNotificationChannel(mChannel);
            mBuilder = new NotificationCompat.Builder(context)
                    .setLights(Color.RED, 300, 300)
                    .setChannelId(CHANNEL_ID)
                    ;

        } else {
            mBuilder = new NotificationCompat.Builder(context)
                    .setPriority(Notification.PRIORITY_HIGH)
                    ;
        }
        int taskAmount = tasks.size();

        if(taskAmount == 1){
             PojoTask task = tasks.get(0);
            if(task != null) {
                notificationIntent.putExtra(MainActivity.key_INTENT_MODE, MainActivity.value_INTENT_MODE_VIEWTASK);
                if (task.getGroup() != null) {
                    notificationIntent.putExtra(MainActivity.key_INTENT_GROUPID,task.getGroup().getId());
                }
                notificationIntent.putExtra(MainActivity.key_INTENT_TASKID, task.getId());
            }
        }

        mBuilder.setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)); //Settings.System.DEFAULT_NOTIFICATION_URI
        mBuilder.setStyle(inboxStyle);
        mBuilder.setVibrate(new long[]{1000, 1000, 1000});
        mBuilder.setSmallIcon(R.mipmap.ic_launcher2);
        mBuilder.setLargeIcon(BitmapFactory.decodeResource(context.getResources(), R.mipmap.ic_launcher2));
        mBuilder.setContentTitle(context.getResources().getString(R.string.notif_unfinished_tasks1) + " "
                + taskAmount + " "
                + context.getResources().getString(R.string.notif_unfinished_tasks2));


        notificationIntent.putExtras(bundle);

        PendingIntent contentIntent = PendingIntent.getActivity(context, 0, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT);
        mBuilder.setContentIntent(contentIntent);
        mBuilder.setAutoCancel(true);
        mNotificationManager.notify(1, mBuilder.build());
    }
}
