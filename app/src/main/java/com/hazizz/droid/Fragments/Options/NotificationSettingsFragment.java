package com.hazizz.droid.Fragments.Options;

import android.app.TimePickerDialog;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CompoundButton;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.TimePicker;

import com.hazizz.droid.Fragments.ParentFragment.ParentFragment;
import com.hazizz.droid.Notification.TaskReporterNotification;
import com.hazizz.droid.R;

public class NotificationSettingsFragment extends ParentFragment {
    private View v;

    private TextView textView_schedule;
    private Switch switch_notify;

    private int _hour, _minute;

    private boolean ignoreFirstOnCheckedChanged = false;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_notification_settings, container, false);

        switch_notify = v.findViewById(R.id.switch_notify);
        switch_notify.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if(isChecked){
                    if(ignoreFirstOnCheckedChanged) {
                        TaskReporterNotification.enable(getContext());
                        TaskReporterNotification.setScheduleForNotification(getContext(), _hour, _minute);
                    }
                }else{
                    TaskReporterNotification.disable(getContext());

                }
                ignoreFirstOnCheckedChanged = true;
            }
        });

        switch_notify.setChecked(TaskReporterNotification.isEnabled(getContext()));

        textView_schedule = v.findViewById(R.id.textView_schedule);
        textView_schedule.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Log.e("hey", "clicked schedule");
                TimePickerDialog.OnTimeSetListener time_listener = new TimePickerDialog.OnTimeSetListener() {
                    @Override
                    public void onTimeSet(TimePicker view, int hour, int minute) {
                        if(!(_hour == hour && _minute == minute)){
                            _hour = hour;
                            _minute = minute;


                            if(switch_notify.isChecked()) {
                                TaskReporterNotification.setSchedule(getContext(), _hour, _minute);
                                TaskReporterNotification.setScheduleForNotification(getContext(), _hour, _minute);
                            }else{
                                TaskReporterNotification.disable(getContext());
                            }


                            Log.e("hey", "saved schedule: " + String.valueOf(hour) + ":" + String.valueOf(minute));
                            setTextViewTime(hour, minute);
                        }
                    }
                };
                int currentHour = TaskReporterNotification.getScheduleHour(getContext());
                int currentMinute = TaskReporterNotification.getScheduleMinute(getContext());

                TimePickerDialog timePickerDialog = new TimePickerDialog(getContext(), time_listener, currentHour,
                        currentMinute, true);
                timePickerDialog.show();
            }
        });

        _hour = TaskReporterNotification.getScheduleHour(getContext());
        _minute = TaskReporterNotification.getScheduleMinute(getContext());
        setTextViewTime(_hour, _minute);

        fragmentSetup(R.string.notification_settings);

        return v;
    }

    private void setTextViewTime(int hour, int minute){
        String s_hour = hour + "";
        String s_minute = minute + "";
        if (hour < 10) {
            s_hour = "0" + hour;
        }
        if (minute < 10) {
            s_minute = "0" + minute;
        }
        textView_schedule.setText(s_hour + ":" + s_minute);
    }

}
