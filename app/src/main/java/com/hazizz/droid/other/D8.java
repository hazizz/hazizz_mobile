package com.hazizz.droid.other;

import android.content.Context;
import android.util.Log;


import com.hazizz.droid.communication.responsePojos.taskPojos.PojoTask;
import com.hazizz.droid.R;

import org.joda.time.DateTime;
import org.joda.time.Days;
import org.joda.time.LocalDate;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class D8 {

    public static class Date{
        String year, month, day;
        LocalDate localDate;

        public Date(LocalDate l){
            localDate = l;
            this.year = Integer.toString(l.getYear());
            this.month = Integer.toString(l.getMonthOfYear());
            if(l.getMonthOfYear() < 10){
                this.month = "0" + this.month;
            }
            this.day = Integer.toString(l.getDayOfMonth());
            if(l.getDayOfMonth() < 10){
                this.day = "0" + this.day;
            }
        }

        public String getYear(){
            return year;
        }
        public String getMonth(){
            return month;
        }
        public String getDay(){
            return day;
        }

        public String getMainFormat(){
            return getYear() + "." + getMonth() + "." +getDay();
        }

        public int daysLeft(){
            return Days.daysBetween(LocalDate.now(), localDate).getDays(); //end.toLocalDate()).getDays()
        }

        public String dayOfWeek(Context c){
            int i = localDate.getDayOfWeek()-1;
            String[] days = c.getResources().getStringArray(R.array.days);
            return days[i];
        }
    }

    private D8(){}

    static LocalDate today = LocalDate.now();

    static LocalDate tomorrow = today.plusDays(1);
    public static DateTimeFormatter dtf_date = DateTimeFormat.forPattern("yyyy-MM-dd");

    public static DateTimeFormatter dtf_time = DateTimeFormat.forPattern("yyyy-MM-dd'T'hh:mm:ss'S'");

    public static Date textToDate(String text){
        LocalDate l = LocalDate.parse(text);
        return new Date(l);
    }

    public static String getDateTomorrow(){
        return tomorrow.toString();
    }
    public static int getDay(LocalDate localDate){
        return localDate.getDayOfMonth();
    }
    public static int getMonth(LocalDate localDate){
        return localDate.getMonthOfYear() + 1;

    }
    public static int getYear(LocalDate localDate){ return localDate.getYear(); }

    public static int getWeek(LocalDate localDate){ return localDate.getWeekOfWeekyear(); }

    public static int getDayOfWeek(LocalDate localDate){
        return localDate.getDayOfWeek();
    }


    public static int getDayOfYear(LocalDate localDate){
        return localDate.getDayOfYear();
    }


    public static LocalDate getNow(){
        return LocalDate.now();
    }



    public static int getTimeInMillis (LocalDate localDate){
        return localDate.getYear();
    }

    public static List<PojoTask> sortTasksByDate(List<PojoTask> data) {
        if(data != null) {
            ArrayList<DateTime> dates = new ArrayList<>();

            for (PojoTask task : data) {
                dates.add(D8.dtf_date.parseDateTime(task.getDueDate()));
            }
            Collections.sort(data, (PojoTask a1, PojoTask a2) -> a1.getDueDate().compareTo(a2.getDueDate()));
            return data;
        }
        return new ArrayList<PojoTask>();
    }

    public static ArrayList< PojoTask> sortCommentsByDate(ArrayList< PojoTask> data) {
        ArrayList<DateTime> dates = new ArrayList<>();
        for (int i = 0; i <= data.size() - 1; i++) {
            dates.add(D8.dtf_time.parseDateTime(data.get(i).getDueDate()));
            Log.e("hey", "dates: " + data.get(i).getDueDate());
        }
        Collections.sort(data, ( PojoTask a1,  PojoTask a2) -> a1.getDueDate().compareTo(a2.getDueDate()));
        return data;
    }

}
