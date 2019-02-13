package com.hazizz.droid;

import android.content.Context;
import android.util.Log;

import com.hazizz.droid.Communication.POJO.Response.getTaskPOJOs.POJOgetTask;

import org.joda.time.DateTime;
import org.joda.time.Days;
import org.joda.time.LocalDate;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.util.ArrayList;
import java.util.Collections;

public abstract class D8 {

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
    public static DateTimeFormatter dtf = DateTimeFormat.forPattern("yyyy-MM-dd");


    public static Date textToDate(String text){
        LocalDate l = LocalDate.parse(text);
        return new Date(l);
    }

    public static String getDateTomorrow(){
        return tomorrow.toString();
    }
    public static String getDay(){
        return Integer.toString(LocalDate.now().getDayOfMonth());
    }
    public static String getMonth(){
        return Integer.toString(LocalDate.now().getMonthOfYear() + 1);

    }
    public static String getYear(){
        return Integer.toString(LocalDate.now().getYear());
    }

    public static String getTimeInMillis (){
        return Integer.toString(LocalDate.now().getYear());
    }

    public static ArrayList<POJOgetTask> sortTasksByDate(ArrayList<POJOgetTask> data) {


        ArrayList<DateTime> dates = new ArrayList<>();
        for (int i = 0; i <= data.size() - 1; i++) {
            dates.add(D8.dtf.parseDateTime(data.get(i).getDueDate()));
        }
        Collections.sort(data, (POJOgetTask a1, POJOgetTask a2) -> a1.getDueDate().compareTo(a2.getDueDate()));
        return data;
    }

    public static ArrayList<POJOgetTask> sortCommentsByDate(ArrayList<POJOgetTask> data) {
        ArrayList<DateTime> dates = new ArrayList<>();
        for (int i = 0; i <= data.size() - 1; i++) {
            dates.add(D8.dtf.parseDateTime(data.get(i).getDueDate()));
            Log.e("hey", "dates: " + data.get(i).getDueDate());
        }
        Collections.sort(data, (POJOgetTask a1, POJOgetTask a2) -> a1.getDueDate().compareTo(a2.getDueDate()));
        return data;
    }

}
