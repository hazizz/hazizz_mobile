package com.hazizz.droid.Fragments.Options;

import android.app.TimePickerDialog;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.TimePicker;

import com.hazizz.droid.Activities.MainActivity;
import com.hazizz.droid.Notification.TaskReporterNotification;
import com.hazizz.droid.R;

public class NotificationSettingsFragment extends Fragment {
    private View v;

    private TextView textView_schedule;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_notification_settings, container, false);

        textView_schedule = v.findViewById(R.id.textView_schedule);
        textView_schedule.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Log.e("hey", "clicked schedule");
                TimePickerDialog.OnTimeSetListener time_listener = new TimePickerDialog.OnTimeSetListener() {
                    @Override
                    public void onTimeSet(TimePicker view, int hour, int minute) {
                        // store the data in one string and set it to text
                        TaskReporterNotification.setNotification(getContext(), hour, minute);
                        Log.e("hey", "saved schedule" + String.valueOf(hour) + ":" + String.valueOf(minute));
                        String s_hour = hour + "";
                        String s_minute = minute + "";
                        if (hour < 10) {
                            s_hour = "0" + hour;
                        }
                        if (minute < 10) {
                            s_minute = "0" + hour;
                        }
                        textView_schedule.setText(s_hour + ":" + s_minute);
                    }
                };
                int currentHour = TaskReporterNotification.getScheduleHour(getContext());
                int currentMinute = TaskReporterNotification.getScheduleHour(getContext());
                new TimePickerDialog(getContext(), time_listener, currentHour,
                        currentMinute, false).show();
            }
        });

        ((MainActivity) getActivity()).onFragmentCreated();

        getActivity().setTitle(R.string.notification_settings);

        return v;
    }

}
