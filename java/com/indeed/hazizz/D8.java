package com.indeed.hazizz;

import android.util.Log;

import com.indeed.hazizz.Communication.POJO.Response.AnnouncementPOJOs.POJOAnnouncement;
import com.indeed.hazizz.Communication.POJO.Response.getTaskPOJOs.POJOgetTask;

import org.joda.time.DateTime;
import org.joda.time.LocalDate;
import org.joda.time.MonthDay;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.util.ArrayList;
import java.util.Collections;

public abstract class D8 {
    static LocalDate today = LocalDate.now();

    static LocalDate tomorrow = today.plusDays(1);
    public static DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd");

    public static String getDateTomorrow(){
        return tomorrow.toString();
    }
    public static String getDay(){
        return Integer.toString(LocalDate.now().getDayOfMonth());
    }
    public static String getMonth(){
     //   return LocalDate.now().monthOfYear().toString();
        return Integer.toString(LocalDate.now().getMonthOfYear() + 1);

    }
    public static String getYear(){
        return Integer.toString(LocalDate.now().getYear());
    }

    public static String getTimeInMillis (){
        return Integer.toString(LocalDate.now().getYear());
    }

    public static ArrayList<POJOgetTask> sortTasksByDate(ArrayList<POJOgetTask> data) {
        ArrayList<POJOgetTask> helper = data;

        ArrayList<DateTime> dates = new ArrayList<>();
        for (int i = 0; i <= data.size() - 1; i++) {
            // dates.add(casted.get(i).getDueDate());
            dates.add(D8.dtf.parseDateTime(data.get(i).getDueDate()));
            Log.e("hey", "dates: " + data.get(i).getDueDate());
        }
        Collections.sort(data, ( POJOgetTask a1, POJOgetTask a2) -> a1.getDueDate().compareTo(a2.getDueDate()));
       // Collections.sort(data, ( a1, a2) -> a1.c-a2.timeStarted);
        return data;
    }



    public static ArrayList<POJOgetTask> sortCommentsByDate(ArrayList<POJOgetTask> data) {
        ArrayList<POJOgetTask> helper = data;

        ArrayList<DateTime> dates = new ArrayList<>();
        for (int i = 0; i <= data.size() - 1; i++) {
            // dates.add(casted.get(i).getDueDate());
            dates.add(D8.dtf.parseDateTime(data.get(i).getDueDate()));
            Log.e("hey", "dates: " + data.get(i).getDueDate());
        }
        Collections.sort(data, ( POJOgetTask a1, POJOgetTask a2) -> a1.getDueDate().compareTo(a2.getDueDate()));
        // Collections.sort(data, ( a1, a2) -> a1.c-a2.timeStarted);
        return data;
    }

}
